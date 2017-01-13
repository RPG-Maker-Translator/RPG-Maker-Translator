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
    public partial class LoadingDialog : Form
    {
        public string Message
        {
            get
            {
                return messageLabel.Text;
            }
            set
            {
                messageLabel.Text = value;
            }
        }

        public LoadingDialog()
        {
            InitializeComponent();
        }

        private void LoadingDialog_Load(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;
        }

        private void LoadingDialog_FormClosed(object sender, FormClosedEventArgs e)
        {
            Cursor.Current = Cursors.Default;
        }
    }
}
