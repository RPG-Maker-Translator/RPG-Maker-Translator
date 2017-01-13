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
    public partial class EditTranslations : Form
    {
        private DataTable dataTable;
        private DataRow editingRow;
        private int deletingRowsTotal = -1;
        private ContextMenu cm = new ContextMenu();
        private ISet<TranslationChange> changeList = new HashSet<TranslationChange>();
        private LoadingDialog waitForm;
        private IDictionary<string, string> originalValues = new Dictionary<string, string>();
        private string outputLanguage = "en";

        public EditTranslations()
        {
            InitializeComponent();
        }

        private void updateDataGrid()
        {
            ShowWaitForm("Loading...");
            dataGrid.DataSource = dataTable;
            dataGrid.Columns[0].ReadOnly = true;
        }

        // From https://stackoverflow.com/questions/1918158/how-do-i-show-a-loading-please-wait-message-in-winforms-for-a-long-loadi#1918955
        protected void ShowWaitForm(string message)
        {
            // don't display more than one wait form at a time
            if (waitForm != null && !waitForm.IsDisposed)
            {
                return;
            }

            waitForm = new LoadingDialog();
            waitForm.Message = message; // "Loading data. Please wait..."
            waitForm.TopMost = true;
            waitForm.StartPosition = FormStartPosition.CenterScreen;
            waitForm.Show();
            waitForm.Refresh();

            // force the wait window to display for at least 700ms so it doesn't just flash on the screen
            System.Threading.Thread.Sleep(700);
            Application.Idle += OnLoaded;
        }

        // From https://stackoverflow.com/questions/1918158/how-do-i-show-a-loading-please-wait-message-in-winforms-for-a-long-loadi#1918955
        private void OnLoaded(object sender, EventArgs e)
        {
            Application.Idle -= OnLoaded;
            waitForm.Close();
        }

        private void EditTranslations_Load(object sender, EventArgs e)
        {
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
                    Dictionary<string, string> values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json.Replace("\n",""));

                    dataTable = new DataTable();

                    dataTable.Columns.Add("Source", typeof(string));
                    dataTable.Columns.Add("Translation", typeof(string));                    

                    foreach (var key in values.Keys)
                    {
                        dataTable.Rows.Add(new object[] { key, values[key] });
                    }
                    updateDataGrid();
                }
            }
        }

        private void applyFilter()
        {
            string query = "";
            if (searchSourceCheckbox.Checked)
            {
                query = String.Format("Source LIKE '%{0}%'", filterTextBox.Text);
                if (searchTranslationCheckbox.Checked)
                {
                    query += " OR ";
                }
            }
            if (searchTranslationCheckbox.Checked)
            {
                query += String.Format("Translation LIKE '%{0}%'", filterTextBox.Text);
            }

            // Unfortunately we have to rebind here since otherwise it will crash randomly
            dataGrid.DataSource = null;
            dataTable.DefaultView.RowFilter = query;
            updateDataGrid();
        }

        private void dataGrid_RowValidating(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dataGrid[0, e.RowIndex].Value == null)
            { 
                e.Cancel = true;
            }
        }

        private void replace()
        {
            bool requireSplitting = wholeWordCheckbox.Checked || !caseSensitiveCheckbox.Checked;
            int totalReplaced = 0;
            foreach (DataRowView rowView in dataTable.DefaultView)
            {
                DataRow row = rowView.Row;
                string rowKey = row[0].ToString();
                String rowText = row[1].ToString();
                String replacementRow = "";
                if (requireSplitting)
                {
                    var split = rowText.Split(null);
                    IList<string> output = new List<string>();
                    foreach (string word in split)
                    {
                        if (wholeWordCheckbox.Checked)
                        {
                            string input = word;
                            string check = findTextBox.Text;
                            if (!caseSensitiveCheckbox.Checked)
                            {
                                input = input.ToLower();
                                check = check.ToLower();
                            }
                            if (input == check)
                            {
                                output.Add(replaceTextBox.Text);
                            }
                            else
                            {
                                output.Add(word);
                            }
                        }
                        else
                        {
                            output.Add(Regex.Replace(word, findTextBox.Text, replaceTextBox.Text, RegexOptions.IgnoreCase));
                        }
                    }
                    String final = String.Join(" ", output.ToArray<string>());
                    replacementRow = final;
                }
                else
                {
                    replacementRow = rowText.Replace(findTextBox.Text, replaceTextBox.Text);
                }

                if (replacementRow != rowText)
                {
                    addToOriginalValueCache(rowKey, rowText);
                    ++totalReplaced;

                    TranslationChange change = new TranslationChange();
                    change.ChangeType = TranslationChange.ChangeTypeEnum.UPDATE;
                    change.Source = rowKey.ToString();
                    change.Translation = originalValues[rowKey];
                    change.NewValue = replacementRow;
                    addChange(change);

                    row[1] = replacementRow;
                }
            }

            MessageBox.Show("Replaced " + totalReplaced.ToString() + " instances of " + findTextBox.Text);
        }

        private void replaceButton_Click(object sender, EventArgs e)
        {
            replace();
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            TranslateUpdateConfirmDialog dialog = new TranslateUpdateConfirmDialog();
            dialog.Changes = changeList;
            if(dialog.ShowDialog() == DialogResult.OK)
            {
                ShowWaitForm("Saving...");
                using (StreamWriter r = new StreamWriter("translation_" + outputLanguage + ".json", false))
                {
                    r.Write("{\n");
                    int index = 0;
                    foreach(DataRow row in dataTable.Rows)
                    {
                        r.Write(String.Format("\"{0}\":\"{1}\"", row[0], row[1]));
                        ++index;
                        if (index != dataTable.Rows.Count)
                        {
                            r.Write(",\n");
                        }
                        else
                        {
                            r.Write("\n");
                        }
                            
                    }
                    r.Write("}");
                }
                changeList.Clear();
            }
        }

        private void OnDeleteClick(object sender, EventArgs e)
        {
            int rows = dataGrid.SelectedRows.Count;
            if(rows == 0)
            {
                MessageBox.Show("No rows selected (you must select entire row)");
                return;
            }
            ShowWaitForm("Deleting...");
            foreach (DataGridViewRow item in dataGrid.SelectedRows)
            {
                TranslationChange change = new TranslationChange();
                change.ChangeType = TranslationChange.ChangeTypeEnum.DELETE;
                change.Source = item.Cells[0].Value.ToString();

                if(originalValues.Keys.Contains(item.Cells[0].ToString()))
                {
                    change.Translation = originalValues[item.Cells[0].ToString()];
                }
                else
                {
                    change.Translation = item.Cells[1].ToString();
                }
                addChange(change);

                dataGrid.Rows.RemoveAt(item.Index);
            }
            MessageBox.Show("Deleted " + rows.ToString() + " Rows");
        }

        private void dataGrid_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                cm.MenuItems.Clear();
                var mi = new MenuItem("Delete Selected Rows");
                mi.MenuItems.Add(mi);
                // handle menu item click event here [as required]
                mi.Click += OnDeleteClick;
                cm.MenuItems.Add(0, mi);
                var bounds = dataGrid.GetCellDisplayRectangle(e.ColumnIndex, e.RowIndex, false);
                if (sender != null)
                {
                    cm.Show(sender as DataGridView, new Point(bounds.X, bounds.Y));
                }
            }
        }

        private void dataGrid_UserDeletedRow(object sender, DataGridViewRowEventArgs e)
        {
            if (dataGrid.SelectedRows.Count == 0)
            {
                MessageBox.Show("Deleted " + deletingRowsTotal.ToString() + " Rows");
                deletingRowsTotal = -1;                
            }
        }

        private void dataGrid_UserDeletingRow(object sender, DataGridViewRowCancelEventArgs e)
        {
            ShowWaitForm("Deleting...");
            string key = e.Row.Cells[0].Value.ToString();
            string value = e.Row.Cells[1].Value.ToString();
            TranslationChange change = new TranslationChange();
            change.ChangeType = TranslationChange.ChangeTypeEnum.DELETE;
            change.Source = key;
            if (originalValues.Keys.Contains(key))
            {
                change.Translation = originalValues[key];
            }
            else
            {
                change.Translation = value;
            }
            addChange(change);

            if (deletingRowsTotal == -1)
            {
              deletingRowsTotal = dataGrid.SelectedRows.Count;
            }
        }

        private void EditTranslations_FormClosing(object sender, FormClosingEventArgs e)
        {
            if(changeList.Count > 0)
            {
                var window = MessageBox.Show(                        
                        "There " + (changeList.Count > 1 ? "are " : "is ") + changeList.Count.ToString() + " unsaved change" + (changeList.Count > 1 ? "s" : "") + 
                        ".\nAll progress will be lost.\nClick \"Update Translation File\" to see details.\n\nContinue?",
                        "Warning",
                        MessageBoxButtons.YesNo);

                if(window == DialogResult.No)
                {
                    e.Cancel = true;
                    return;
                }                
            }

            changeList.Clear();
            dataTable = null;
            deletingRowsTotal = -1;
        }

        private void dataGrid_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            var dataRow = editingRow;

            TranslationChange change = new TranslationChange();
            change.Source = dataRow[0].ToString();
            string originalValue = originalValues[change.Source];
            if (originalValue != dataRow[1].ToString())
            {
                change.ChangeType = TranslationChange.ChangeTypeEnum.UPDATE;
                change.Translation = originalValue;
                change.NewValue = dataRow[1].ToString();
                addChange(change);
            }
            // Edited back to default value
            else if(changeList.Contains(change))
            {
                changeList.Remove(change);
                if(changeList.Count == 0)
                {
                    updateButton.Enabled = false;
                }
            }

            editingRow = null;
        }

        private void addChange(TranslationChange change)
        {
            if(changeList.Contains(change))
            {
                changeList.Remove(change);
            }
            changeList.Add(change);
            updateButton.Enabled = true;
        }

        private void searchSourceCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            applyFilter();
        }

        private void searchTranslationCheckbox_CheckedChanged(object sender, EventArgs e)
        {
            applyFilter();
        }

        private void applyButton_Click(object sender, EventArgs e)
        {
            applyFilter();
        }

        private void clearFilterButton_Click(object sender, EventArgs e)
        {
            filterTextBox.Text = "";
            applyFilter();
        }

        private void EditTranslations_KeyPress(object sender, KeyPressEventArgs e)
        {

        }

        private void filterTextBox_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Return)
            {
                applyFilter();
                e.Handled = true;
            }
        }

        private void replaceTextBox_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Return)
            {
                replace();
                e.Handled = true;
            }
        }

        private void addToOriginalValueCache(string key, string value)
        {
            if (!originalValues.Keys.Contains(key))
            {
                originalValues[key] = value;
            }
        }

        private void dataGrid_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            editingRow = dataTable.DefaultView[e.RowIndex].Row;
            addToOriginalValueCache(dataTable.DefaultView[e.RowIndex][0].ToString(), dataTable.DefaultView[e.RowIndex][1].ToString());
        }
    }
}
