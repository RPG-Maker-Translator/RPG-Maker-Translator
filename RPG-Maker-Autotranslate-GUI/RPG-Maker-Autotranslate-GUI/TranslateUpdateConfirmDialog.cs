using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RPGMakerTranslator
{
    public partial class TranslateUpdateConfirmDialog : Form
    {
        public ISet<TranslationChange> Changes { get; set; }
        DataTable dataTable;

        public TranslateUpdateConfirmDialog()
        {
            InitializeComponent();
        }

        private void TranslateUpdateConfirmDialog_Load(object sender, EventArgs e)
        {
            dataTable = new DataTable();

            dataTable.Columns.Add("Change Type", typeof(string));
            dataTable.Columns.Add("Source", typeof(string));
            dataTable.Columns.Add("Original Translation", typeof(string));
            dataTable.Columns.Add("New Translation", typeof(string));

            foreach (TranslationChange change in Changes)
            {
                string changeType = change.ChangeType == TranslationChange.ChangeTypeEnum.DELETE ? "DELETE" : "UPDATE";
                dataTable.Rows.Add(new object[] { changeType, change.Source, change.Translation, change.NewValue });
            }
            dataGrid.DataSource = dataTable;
        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }
}
