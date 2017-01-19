using Newtonsoft.Json;
using RPGMakerTranslator;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Timers;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class RPGTranslator : Form
    {
        class FileReadTimer : System.Timers.Timer
        {
            public string Path;
        }

        private FileReadTimer updateFileTimer;
        private Font outputFont = new Font("SimSun", 10);
        private Process translationProcess;
        private int logLines = 0;
        private int lastAutoScrollLength = 0;
        private const int SCROLL_HISTORY_LINES = 2500;
        private string outputLanguage = "en";

        public RPGTranslator()
        {
            InitializeComponent();
            outputTextbox.MouseWheel += OnScroll;
        }

        private void stopLogging()
        {            
            logLines = 0;
            lastAutoScrollLength = 0;
            progressBar.Value = 0;
            autoScrollCheckbox.Checked = true;
            autoScrollCheckbox.Visible = false;
            if (updateFileTimer != null && updateFileTimer.Enabled)
            { 
                updateFileTimer.Enabled = false;
                updateFileTimer.Close();
            }
            editTranslationsButton.Enabled = true;
            openDirectoryButton.Enabled = true;
            directoryTextBox.Enabled = true;
            settingsToolStripMenuItem.Visible = true;
        }

        private void OnVScroll(object sender, EventArgs e)
        {
            autoScrollCheckbox.Checked = false;
        }

        void OnScroll(object sender, MouseEventArgs e)
        {
            autoScrollCheckbox.Checked = false;
        }

        private void openDirectoryButton_Click(object sender, EventArgs e)
        {
            OpenFileDialog openDirectoryDialog = new OpenFileDialog();
            openDirectoryDialog.Title = "Locate RPG Maker Game";
            openDirectoryDialog.Filter = "RPG Maker Games (Game.exe)|Game.exe";
            openDirectoryDialog.FilterIndex = 1;
            openDirectoryDialog.RestoreDirectory = true;

            if (!String.IsNullOrEmpty(directoryTextBox.Text))
            {
                openDirectoryDialog.InitialDirectory = directoryTextBox.Text;
            }
            else if(File.Exists("lastOpened"))
            {
                using (StreamReader r = new StreamReader("lastOpened"))
                {
                    string directory = r.ReadToEnd();
                    if(Directory.Exists(directory))
                    {
                        openDirectoryDialog.InitialDirectory = directory;
                    }
                }
            }
            DialogResult result = openDirectoryDialog.ShowDialog();
            if (!string.IsNullOrWhiteSpace(openDirectoryDialog.FileName))
            {
                directoryTextBox.Text = Path.GetDirectoryName(openDirectoryDialog.FileName);
            }
        }

        private void translateButton_Click(object sender, EventArgs e)
        {
            if(directoryTextBox.Text == "")
            { 
                MessageBox.Show("No game directory selected");
                return;
            }
            if(!File.Exists("settings.json"))
            {
                MessageBox.Show("No output directory selected (save settings)");
                return;
            }

            stopLogging();
            if (translateButton.Text == "Translate")
            {
                translateButton.Text = "Abort";
            }
            else 
            {
                if (translationProcess != null)
                {
                    try
                    { 
                        translationProcess.Kill();
                        translationProcess.WaitForExit();
                    }
                    catch { }
                }
                translateButton.Text = "Translate";
                return;
            }

            using (StreamWriter r = new StreamWriter("lastOpened", false))
            {
                r.Write(directoryTextBox.Text);
            }

            Cursor.Current = Cursors.WaitCursor;
            outputTextbox.Text = "";
            editTranslationsButton.Enabled = false;
            openDirectoryButton.Enabled = false;
            directoryTextBox.Enabled = false;            
            autoScrollCheckbox.Visible = true;
            autoScrollCheckbox.Checked = true;
            settingsToolStripMenuItem.Visible = false;

            updateFileTimer = new FileReadTimer();
            updateFileTimer.Path = directoryTextBox.Text;
            updateFileTimer.Elapsed += new ElapsedEventHandler(updateLogOutput);
            updateFileTimer.Interval = 2000;
            updateFileTimer.Enabled = true;

            translationProcess = new Process();
            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.UseShellExecute = false;
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.FileName = "ruby";
            startInfo.WorkingDirectory = Directory.GetCurrentDirectory();
            startInfo.CreateNoWindow = true;
            startInfo.Arguments = String.Format("\"{0}\" \"{1}\"", Path.Combine(Directory.GetCurrentDirectory(), "auto_translate.rb"), directoryTextBox.Text);
            translationProcess.Exited += new EventHandler(processExited);
            translationProcess.EnableRaisingEvents = true;
            translationProcess.StartInfo = startInfo;
            translationProcess.Start();
        }
        
        private void processExited(object sender, System.EventArgs e)
        {
            this.Invoke((MethodInvoker)delegate
            {
                string dirName = Path.GetFileName(directoryTextBox.Text);
                updateLogWindow(dirName);

                if (!Directory.Exists(getOutputPath(dirName)))
                {
                    MessageBox.Show("Output directory not found, operation unsuccessful", "Error", MessageBoxButtons.OK);
                    return;
                }
                
                translateButton.Text = "Translate";
                var window = MessageBox.Show("Open Game folder?", "Operation Finished", MessageBoxButtons.YesNo);
                if (window == DialogResult.Yes)
                {
                    Process.Start(new System.Diagnostics.ProcessStartInfo()
                    {                         
                        FileName = getOutputPath(dirName),
                        UseShellExecute = true,
                        Verb = "open"
                    });
                }
                stopLogging();
                updateCachedAmount();
            });
        }

        private string getOutputPath(string sourceDirectory)
        {
            string path = "";
            string modifiedSourceDirectory = sourceDirectory.Replace("[", "(").Replace("]", ")");
            if (File.Exists("settings.json"))
            {
                using (StreamReader r = new StreamReader("settings.json"))
                {
                    string json = r.ReadToEnd();
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                    if (values.Keys.Contains("output"))
                    {
                        path = Path.Combine(values["output"], modifiedSourceDirectory);
                    }
                    if (values.Keys.Contains("outputLanguage"))
                    {
                        outputLanguage = values["outputLanguage"];
                    }
                }
            }

            if (String.IsNullOrEmpty(path))
            {
                path = Path.Combine(Environment.CurrentDirectory, "output", modifiedSourceDirectory);
            }
            return path;
        }

        private void updateLogWindow(string dirName)
        {
            string path = Path.Combine(getOutputPath(dirName), "RPG Maker Auto Translate - " + outputLanguage + ".log");

            if (File.Exists(path.Replace("/", @"\")))
            {
                Cursor.Current = Cursors.Default;
                string text = "";
                try
                {
                    using (StreamReader r = new StreamReader(path))
                    {
                        text = r.ReadToEnd();
                    }
                }
                catch (IOException ex)
                {
                    return;
                }
                int bufferLength = text.Length;
                text = text.Substring(logLines, text.Length - logLines);

                int progressLine = text.LastIndexOf("Progress: Total");
                int progress = 0;
                if (progressLine != -1)
                {
                    string line = text.Substring(progressLine);
                    line = line.Substring("Progress: Total".Length + 1, line.IndexOf("]") - "Progress: Total".Length + 1);
                    string done = line.Substring(1, line.IndexOf("/") - 1);
                    string total = line.Substring(line.IndexOf("/") + 1, line.IndexOf("]") - line.IndexOf("/") - 1);
                    progress = Int32.Parse(total) > 0 ? Math.Min((int)Math.Ceiling(Decimal.Parse(done) / Decimal.Parse(total) * 100), 100) : 0;
                }

                this.Invoke((MethodInvoker)delegate
                {
                    if (progress != 0)
                    {
                        progressBar.Value = progress;
                    }
                    outputTextbox.Font = outputFont;
                    outputTextbox.SelectionFont = outputFont;
                    string[] lines = Regex.Split(text, @"\r?\n|\r");

                    if (lines.Length > SCROLL_HISTORY_LINES)
                    {
                        string newText = "";
                        for (int i = lines.Length - SCROLL_HISTORY_LINES; i < lines.Length; ++i)
                        {
                            newText += lines[i] + Environment.NewLine;
                        }
                        outputTextbox.Clear();
                        outputTextbox.Text = newText;
                    }
                    else
                    {
                        outputTextbox.Text += text;
                    }

                    if (autoScrollCheckbox.Checked && lastAutoScrollLength != outputTextbox.TextLength)
                    {
                        outputTextbox.SelectionStart = outputTextbox.TextLength;
                        outputTextbox.ScrollToCaret();
                        lastAutoScrollLength = outputTextbox.TextLength;
                    }
                });
                logLines = bufferLength;
            }
        }

        private void updateLogOutput(object source, ElapsedEventArgs e)
        {            
            string dirName = Path.GetFileName(((FileReadTimer)source).Path);
            updateLogWindow(dirName);
        }

        private void updateCachedAmount()
        {
            outputLanguage = "en";
            if (File.Exists("settings.json"))
            {
                using (StreamReader r = new StreamReader("settings.json"))
                {
                    string json = r.ReadToEnd();
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                    if (values.Keys.Contains("outputLanguage"))
                    {
                        outputLanguage = values["outputLanguage"];
                    }
                }
            }

            if (File.Exists("translation_" + outputLanguage + ".json"))
            {
                using (StreamReader r = new StreamReader("translation_" + outputLanguage + ".json"))
                {
                    string json = r.ReadToEnd();
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                    numberCachedLabel.Text = values.Keys.Count.ToString();
                    editTranslationsButton.Enabled = true;
                }
            }
            else
            {
                numberCachedLabel.Text = "None";
                editTranslationsButton.Enabled = false;
            }
        }

        private void RPGTranslator_Load(object sender, EventArgs e)
        {
            updateCachedAmount();
        }

        private void editTranslationsButton_Click(object sender, EventArgs e)
        {
            EditTranslations editTranslations = new EditTranslations();
            editTranslations.StartPosition = FormStartPosition.CenterScreen;
            editTranslations.Show();
        }

        private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            var settings = new Settings();
            if(settings.ShowDialog() == DialogResult.OK)
            {
                updateCachedAmount();
            }            
        }

        private void outputTextbox_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.Handled = true;
        }

        private void RPGTranslator_FormClosing(object sender, FormClosingEventArgs e)
        {
            if(translationProcess != null)
            {
                try
                {
                    translationProcess.Kill();
                    translationProcess.WaitForExit();
                }
                catch { }
            }
        }
    }
}
