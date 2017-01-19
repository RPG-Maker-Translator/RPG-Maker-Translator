using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RPGMakerTranslator
{
    public partial class Settings : Form
    {
        DataTable languagesDataTable = null;
        string[] translateOptions = new string[] { "Translate All", "Translate Single Lines", "Skip" };
        string[] fileNames = new string[]
        {
            "Actors",
            "Animators",
            "Armors",
            "Classes",
            "CommonEvents",
            "Enemies",
            "Items",
            "Map",
            "Scripts",
            "Skills",
            "States",
            "System",
            "Tilesets",
            "Troops",
            "Weapons",
            "Other"
        };

        IDictionary<string, ComboBox> comboBoxes = new Dictionary<string, ComboBox>();

        public Settings()
        {
            InitializeComponent();
        }

        private void Settings_Load(object sender, EventArgs e)
        {
            ToolTip outputToolTip = new ToolTip();
            outputToolTip.SetToolTip(outputDirectoryTextBox, "The original game directory will be copied into this root directory leaving the original untouched.");

            ToolTip showTranslationToolTip = new ToolTip();
            outputToolTip.SetToolTip(showTranslationCheckbox, "Whether the result of cache hits and translations will be shown in the log or only the source Japanese block");

            ToolTip translateFromCacheToolTip = new ToolTip();
            outputToolTip.SetToolTip(translateFromCacheOnlyCheckbox, "Do not do API calls to translate blocks that are not in the translation cache file");

            ToolTip deleteExistingToolTip = new ToolTip();
            outputToolTip.SetToolTip(deleteExistingCheckbox, "Whether to delete an existing copied game folder before doing work. If unchecked if a directory already exists the copy step from the original will be skipped.");

            ToolTip skipExtractToolTip = new ToolTip();
            outputToolTip.SetToolTip(skipDataExtractCheckbox, "Skip extracting the assets and data files from the data file (Game.rgssad/ Game.rgss2a/ Game.rgss3a)");

            ToolTip skipJsonDumpToolTip = new ToolTip();
            outputToolTip.SetToolTip(skipJsonDumpCheckbox, "Skip dumping the rxdata / rvdata / rvdata2 files into JSON");

            ToolTip skipTranslationToolTip = new ToolTip();
            outputToolTip.SetToolTip(skipTranslateCheckbox, "Skip processing translation on all JSON files");

            ToolTip overrideToolTip = new ToolTip();
            outputToolTip.SetToolTip(characterOverrideTextbox, "Characters will not break translation blocks, for example with a \",\" in the box.\nCharacters should be entered side by side without being escaped or having whitespace, commas, etc");

            if (File.Exists("languages.json"))
            {
                using (StreamReader r = new StreamReader("languages.json"))
                {
                    string json = r.ReadToEnd();
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json.Replace("\n", ""));
                    languagesDataTable = new DataTable();
                    languagesDataTable.Columns.Add("Code", typeof(string));
                    languagesDataTable.Columns.Add("Display", typeof(string));

                    int englishIndex = 0;
                    int index = 0;
                    foreach (var key in values.Keys)
                    {
                        if(key == "en")
                        {
                            englishIndex = index;
                        }
                        languagesDataTable.Rows.Add(new object[] { key, values[key] });
                        index++;
                    }

                    outputLanguageComboBox.DataSource = languagesDataTable;
                    outputLanguageComboBox.DisplayMember = "Display";
                    outputLanguageComboBox.SelectedIndex = englishIndex;
                }
            }

            Dictionary<string, string> filterValues = new Dictionary<string, string>();        
            if (File.Exists("settings.json"))
            {
                try
                {
                    using (StreamReader r = new StreamReader("settings.json"))
                    {
                        string json = r.ReadToEnd();
                        Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
                        outputDirectoryTextBox.Text = values["output"].Replace("/", @"\");
                        showTranslationCheckbox.Checked = values["showTranslation"] != "0" ? true : false;
                        translateFromCacheOnlyCheckbox.Checked = values["cacheOnly"] != "0" ? true : false;
                        deleteExistingCheckbox.Checked = values["deleteExisting"] != "0" ? true : false;
                        skipDataExtractCheckbox.Checked = values["skipDataExtract"] != "0" ? true : false;
                        skipJsonDumpCheckbox.Checked = values["skipJsonDump"] != "0" ? true : false;
                        skipTranslateCheckbox.Checked = values["skipTranslate"] != "0" ? true : false;
                        logCacheHitsCheckbox.Checked = values["logCacheHits"] != "0" ? true : false;
                        logTranslationsCheckbox.Checked = values["logTranslations"] != "0" ? true : false;
                        breakBlocksOnKatakanaCheckbox.Checked = values["breakBlocksOnKatakana"] != "0" ? true : false;
                        translateScriptsCheckbox.Checked = values["translateScripts"] != "0" ? true : false;
                        translateLinesWithVars.Checked = values["translateLinesWithVars"] != "0" ? true : false;
                        characterOverrideTextbox.Text = values["overrideCharacters"].ToString();

                        if (values.Keys.Contains("outputLanguage"))
                        {
                            string code = values["outputLanguage"];
                            for (int i = 0; i < languagesDataTable.Rows.Count; ++i)
                            {
                                DataRow row = languagesDataTable.Rows[i];
                                if (row["Code"].ToString() == code)
                                {
                                    outputLanguageComboBox.SelectedIndex = i;
                                    break;
                                }
                            }
                        }

                        foreach (string file in fileNames)
                        {
                            if (values.Keys.Contains(file))
                            {
                                filterValues.Add(file, values[file].ToString());
                            }
                        }

                    }
                }
                catch { }
            }

            allFiltersComboBox.DataSource = new ArrayList(translateOptions);

            flowLayoutPanel1.Controls.Clear();
            comboBoxes.Clear();
            foreach (string file in fileNames)
            {
                Panel panel = new Panel();
                panel.Dock = DockStyle.Left;

                Label label = new Label();
                label.Text = file;

                ComboBox comboBox = new ComboBox();
                comboBox.DropDownStyle = ComboBoxStyle.DropDownList;
                comboBox.DataSource = new ArrayList(translateOptions);
                flowLayoutPanel1.Controls.Add(label);
                flowLayoutPanel1.Controls.Add(comboBox);
                comboBoxes.Add(file, comboBox);

                if (filterValues.Count > 0 && filterValues.ContainsKey(file))
                {
                    for(int i = 0; i < translateOptions.Length; ++i)
                    {
                        if (translateOptions[i] == filterValues[file])
                        {
                            comboBox.SelectedIndex = i;
                        }
                    }
                }
                else
                {
                    comboBox.SelectedIndex = 0;
                }
            }
            flowLayoutPanel1.BringToFront();
        }

        private void chooseDirectoryButton_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            DialogResult result = fbd.ShowDialog();

            if (!string.IsNullOrWhiteSpace(fbd.SelectedPath))
            {
                outputDirectoryTextBox.Text = fbd.SelectedPath;
            }
        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            if (Regex.IsMatch(@outputDirectoryTextBox.Text, "[\\[\\]]"))
            {
                MessageBox.Show("Output path cannot contain any brackets.\nrmxp_translator tool will fail.");
                return;
            }
            using (StreamWriter r = new StreamWriter("settings.json", false))
            {
                r.Write("{\n");
                r.Write("\"output\": \"" + Regex.Replace(@outputDirectoryTextBox.Text, "\\\\", "/") + "\",\n");
                r.Write("\"showTranslation\": " + (showTranslationCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"cacheOnly\": " + (translateFromCacheOnlyCheckbox.Checked ? "1" : "0") + ",\n");                
                r.Write("\"deleteExisting\": " + (deleteExistingCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"skipDataExtract\": " + (skipDataExtractCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"skipJsonDump\": " + (skipJsonDumpCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"skipTranslate\": " + (skipTranslateCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"logCacheHits\": " + (logCacheHitsCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"logTranslations\": " + (logTranslationsCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"breakBlocksOnKatakana\": " + (breakBlocksOnKatakanaCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"translateScripts\": " + (translateScriptsCheckbox.Checked ? "1" : "0") + ",\n");
                r.Write("\"translateLinesWithVars\": " + (translateLinesWithVars.Checked ? "1" : "0") + ",\n");
                r.Write("\"overrideCharacters\": \"" + characterOverrideTextbox.Text + "\",\n");
                r.Write("\"outputLanguage\": \"" + ((DataRowView)outputLanguageComboBox.SelectedValue)["Code"] +"\",\n");                
                for (int i = 0; i < fileNames.Length; ++i)
                {
                    string file = fileNames[i];
                    ComboBox comboBox = comboBoxes[file];
                    if(comboBox != null)
                    {
                        r.Write("\"" + file + "\": \"" + comboBox.SelectedValue + "\"");
                    }
                    else
                    {
                        r.Write("\"" + file + "\": \"" + translateOptions[0] + "\"");
                    }

                    if(i != fileNames.Length - 1)
                    {
                        r.Write(",");
                    }
                    r.Write("\n");
                }

                r.Write("}");
            }
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void allFiltersComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach(Control c in flowLayoutPanel1.Controls)
            {
                if(c.GetType() == typeof(ComboBox))
                {
                    ((ComboBox)c).SelectedIndex = allFiltersComboBox.SelectedIndex;
                }
            }

            allFiltersComboBox.SelectedIndexChanged -= allFiltersComboBox_SelectedIndexChanged;
            allFiltersComboBox.SelectedIndex = -1;
            allFiltersComboBox.SelectedIndexChanged += allFiltersComboBox_SelectedIndexChanged;
        }
    }
}
