namespace RPGMakerTranslator
{
    partial class EditTranslations
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(EditTranslations));
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.filterTextBox = new System.Windows.Forms.TextBox();
            this.applyButton = new System.Windows.Forms.Button();
            this.searchSourceCheckbox = new System.Windows.Forms.CheckBox();
            this.dataGrid = new System.Windows.Forms.DataGridView();
            this.panel1 = new System.Windows.Forms.Panel();
            this.searchTranslationCheckbox = new System.Windows.Forms.CheckBox();
            this.updateButton = new System.Windows.Forms.Button();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panel3 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.panel6 = new System.Windows.Forms.Panel();
            this.wholeWordCheckbox = new System.Windows.Forms.CheckBox();
            this.caseSensitiveCheckbox = new System.Windows.Forms.CheckBox();
            this.replaceButton = new System.Windows.Forms.Button();
            this.replaceTextBox = new System.Windows.Forms.TextBox();
            this.findTextBox = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.clearFilterButton = new System.Windows.Forms.Button();
            this.flowLayoutPanel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGrid)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel6.SuspendLayout();
            this.SuspendLayout();
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.filterTextBox);
            this.flowLayoutPanel1.Controls.Add(this.applyButton);
            this.flowLayoutPanel1.Controls.Add(this.clearFilterButton);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(20, 14);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(966, 36);
            this.flowLayoutPanel1.TabIndex = 0;
            // 
            // filterTextBox
            // 
            this.filterTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.filterTextBox.Location = new System.Drawing.Point(3, 3);
            this.filterTextBox.Name = "filterTextBox";
            this.filterTextBox.Size = new System.Drawing.Size(802, 20);
            this.filterTextBox.TabIndex = 0;
            this.filterTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.filterTextBox_KeyPress);
            // 
            // applyButton
            // 
            this.applyButton.Location = new System.Drawing.Point(811, 3);
            this.applyButton.Name = "applyButton";
            this.applyButton.Size = new System.Drawing.Size(75, 23);
            this.applyButton.TabIndex = 2;
            this.applyButton.Text = "Apply Filter";
            this.applyButton.UseVisualStyleBackColor = true;
            this.applyButton.Click += new System.EventHandler(this.applyButton_Click);
            // 
            // searchSourceCheckbox
            // 
            this.searchSourceCheckbox.AutoSize = true;
            this.searchSourceCheckbox.Checked = true;
            this.searchSourceCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.searchSourceCheckbox.Location = new System.Drawing.Point(6, 6);
            this.searchSourceCheckbox.Name = "searchSourceCheckbox";
            this.searchSourceCheckbox.Size = new System.Drawing.Size(98, 17);
            this.searchSourceCheckbox.TabIndex = 5;
            this.searchSourceCheckbox.Text = "Include Source";
            this.searchSourceCheckbox.UseVisualStyleBackColor = true;
            this.searchSourceCheckbox.CheckedChanged += new System.EventHandler(this.searchSourceCheckbox_CheckedChanged);
            // 
            // dataGrid
            // 
            this.dataGrid.AllowUserToAddRows = false;
            this.dataGrid.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dataGrid.ClipboardCopyMode = System.Windows.Forms.DataGridViewClipboardCopyMode.EnableWithoutHeaderText;
            this.dataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGrid.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGrid.Location = new System.Drawing.Point(20, 136);
            this.dataGrid.Name = "dataGrid";
            this.dataGrid.Size = new System.Drawing.Size(966, 277);
            this.dataGrid.TabIndex = 1;
            this.dataGrid.CellBeginEdit += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dataGrid_CellBeginEdit);
            this.dataGrid.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGrid_CellEndEdit);
            this.dataGrid.CellMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dataGrid_CellMouseClick);
            this.dataGrid.RowValidating += new System.Windows.Forms.DataGridViewCellCancelEventHandler(this.dataGrid_RowValidating);
            this.dataGrid.UserDeletedRow += new System.Windows.Forms.DataGridViewRowEventHandler(this.dataGrid_UserDeletedRow);
            this.dataGrid.UserDeletingRow += new System.Windows.Forms.DataGridViewRowCancelEventHandler(this.dataGrid_UserDeletingRow);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.searchTranslationCheckbox);
            this.panel1.Controls.Add(this.searchSourceCheckbox);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(20, 50);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(966, 27);
            this.panel1.TabIndex = 2;
            // 
            // searchTranslationCheckbox
            // 
            this.searchTranslationCheckbox.AutoSize = true;
            this.searchTranslationCheckbox.Checked = true;
            this.searchTranslationCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.searchTranslationCheckbox.Location = new System.Drawing.Point(116, 6);
            this.searchTranslationCheckbox.Name = "searchTranslationCheckbox";
            this.searchTranslationCheckbox.Size = new System.Drawing.Size(116, 17);
            this.searchTranslationCheckbox.TabIndex = 6;
            this.searchTranslationCheckbox.Text = "Include Translation";
            this.searchTranslationCheckbox.UseVisualStyleBackColor = true;
            this.searchTranslationCheckbox.CheckedChanged += new System.EventHandler(this.searchTranslationCheckbox_CheckedChanged);
            // 
            // updateButton
            // 
            this.updateButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.updateButton.Enabled = false;
            this.updateButton.Location = new System.Drawing.Point(20, 413);
            this.updateButton.Name = "updateButton";
            this.updateButton.Size = new System.Drawing.Size(966, 35);
            this.updateButton.TabIndex = 3;
            this.updateButton.Text = "Update Translation File";
            this.updateButton.UseVisualStyleBackColor = true;
            this.updateButton.Click += new System.EventHandler(this.updateButton_Click);
            // 
            // panel2
            // 
            this.panel2.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel2.Location = new System.Drawing.Point(0, 14);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(20, 434);
            this.panel2.TabIndex = 4;
            // 
            // panel3
            // 
            this.panel3.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel3.Location = new System.Drawing.Point(986, 14);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(20, 434);
            this.panel3.TabIndex = 5;
            // 
            // panel4
            // 
            this.panel4.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel4.Location = new System.Drawing.Point(0, 448);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(1006, 20);
            this.panel4.TabIndex = 6;
            // 
            // panel5
            // 
            this.panel5.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel5.Location = new System.Drawing.Point(0, 0);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(1006, 14);
            this.panel5.TabIndex = 7;
            // 
            // panel6
            // 
            this.panel6.Controls.Add(this.wholeWordCheckbox);
            this.panel6.Controls.Add(this.caseSensitiveCheckbox);
            this.panel6.Controls.Add(this.replaceButton);
            this.panel6.Controls.Add(this.replaceTextBox);
            this.panel6.Controls.Add(this.findTextBox);
            this.panel6.Controls.Add(this.label3);
            this.panel6.Controls.Add(this.label2);
            this.panel6.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel6.Location = new System.Drawing.Point(20, 77);
            this.panel6.Name = "panel6";
            this.panel6.Size = new System.Drawing.Size(966, 59);
            this.panel6.TabIndex = 8;
            // 
            // wholeWordCheckbox
            // 
            this.wholeWordCheckbox.AutoSize = true;
            this.wholeWordCheckbox.Checked = true;
            this.wholeWordCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.wholeWordCheckbox.Location = new System.Drawing.Point(116, 36);
            this.wholeWordCheckbox.Name = "wholeWordCheckbox";
            this.wholeWordCheckbox.Size = new System.Drawing.Size(110, 17);
            this.wholeWordCheckbox.TabIndex = 6;
            this.wholeWordCheckbox.Text = "Whole Word Only";
            this.wholeWordCheckbox.UseVisualStyleBackColor = true;
            // 
            // caseSensitiveCheckbox
            // 
            this.caseSensitiveCheckbox.AutoSize = true;
            this.caseSensitiveCheckbox.Checked = true;
            this.caseSensitiveCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.caseSensitiveCheckbox.Location = new System.Drawing.Point(7, 36);
            this.caseSensitiveCheckbox.Name = "caseSensitiveCheckbox";
            this.caseSensitiveCheckbox.Size = new System.Drawing.Size(96, 17);
            this.caseSensitiveCheckbox.TabIndex = 5;
            this.caseSensitiveCheckbox.Text = "Case Sensitive";
            this.caseSensitiveCheckbox.UseVisualStyleBackColor = true;
            // 
            // replaceButton
            // 
            this.replaceButton.Location = new System.Drawing.Point(890, 6);
            this.replaceButton.Name = "replaceButton";
            this.replaceButton.Size = new System.Drawing.Size(70, 23);
            this.replaceButton.TabIndex = 4;
            this.replaceButton.Text = "Replace";
            this.replaceButton.UseVisualStyleBackColor = true;
            this.replaceButton.Click += new System.EventHandler(this.replaceButton_Click);
            // 
            // replaceTextBox
            // 
            this.replaceTextBox.Location = new System.Drawing.Point(456, 8);
            this.replaceTextBox.Name = "replaceTextBox";
            this.replaceTextBox.Size = new System.Drawing.Size(430, 20);
            this.replaceTextBox.TabIndex = 3;
            this.replaceTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.replaceTextBox_KeyPress);
            // 
            // findTextBox
            // 
            this.findTextBox.Location = new System.Drawing.Point(57, 8);
            this.findTextBox.Name = "findTextBox";
            this.findTextBox.Size = new System.Drawing.Size(358, 20);
            this.findTextBox.TabIndex = 2;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(421, 11);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(29, 13);
            this.label3.TabIndex = 1;
            this.label3.Text = "With";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(4, 11);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 13);
            this.label2.TabIndex = 0;
            this.label2.Text = "Replace";
            // 
            // clearFilterButton
            // 
            this.clearFilterButton.Location = new System.Drawing.Point(892, 3);
            this.clearFilterButton.Name = "clearFilterButton";
            this.clearFilterButton.Size = new System.Drawing.Size(69, 23);
            this.clearFilterButton.TabIndex = 3;
            this.clearFilterButton.Text = "Clear Filter";
            this.clearFilterButton.UseVisualStyleBackColor = true;
            this.clearFilterButton.Click += new System.EventHandler(this.clearFilterButton_Click);
            // 
            // EditTranslations
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1006, 468);
            this.Controls.Add(this.dataGrid);
            this.Controls.Add(this.panel6);
            this.Controls.Add(this.updateButton);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel4);
            this.Controls.Add(this.panel5);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "EditTranslations";
            this.Text = "Edit Translations";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.EditTranslations_FormClosing);
            this.Load += new System.EventHandler(this.EditTranslations_Load);
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGrid)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel6.ResumeLayout(false);
            this.panel6.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.CheckBox searchSourceCheckbox;
        private System.Windows.Forms.DataGridView dataGrid;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.CheckBox searchTranslationCheckbox;
        private System.Windows.Forms.Button updateButton;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.TextBox filterTextBox;
        private System.Windows.Forms.Panel panel6;
        private System.Windows.Forms.TextBox replaceTextBox;
        private System.Windows.Forms.TextBox findTextBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button replaceButton;
        private System.Windows.Forms.CheckBox wholeWordCheckbox;
        private System.Windows.Forms.CheckBox caseSensitiveCheckbox;
        private System.Windows.Forms.Button applyButton;
        private System.Windows.Forms.Button clearFilterButton;
    }
}