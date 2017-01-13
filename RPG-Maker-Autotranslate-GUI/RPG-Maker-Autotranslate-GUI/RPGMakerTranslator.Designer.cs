namespace WindowsFormsApplication1
{
    partial class RPGTranslator
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(RPGTranslator));
            this.directoryTextBox = new System.Windows.Forms.TextBox();
            this.openDirectoryButton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.translateButton = new System.Windows.Forms.Button();
            this.cachedTranslationLabel = new System.Windows.Forms.Label();
            this.editTranslationsButton = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.numberCachedLabel = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.outputTextbox = new System.Windows.Forms.RichTextBox();
            this.panel8 = new System.Windows.Forms.Panel();
            this.autoScrollCheckbox = new System.Windows.Forms.CheckBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.panel4 = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.settingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.panel6 = new System.Windows.Forms.Panel();
            this.panel7 = new System.Windows.Forms.Panel();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel8.SuspendLayout();
            this.panel5.SuspendLayout();
            this.menuStrip1.SuspendLayout();
            this.panel7.SuspendLayout();
            this.SuspendLayout();
            // 
            // directoryTextBox
            // 
            this.directoryTextBox.AllowDrop = true;
            this.directoryTextBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.directoryTextBox.Location = new System.Drawing.Point(0, 0);
            this.directoryTextBox.Name = "directoryTextBox";
            this.directoryTextBox.Size = new System.Drawing.Size(1343, 20);
            this.directoryTextBox.TabIndex = 5;
            // 
            // openDirectoryButton
            // 
            this.openDirectoryButton.Dock = System.Windows.Forms.DockStyle.Right;
            this.openDirectoryButton.Location = new System.Drawing.Point(1343, 0);
            this.openDirectoryButton.Name = "openDirectoryButton";
            this.openDirectoryButton.Size = new System.Drawing.Size(24, 23);
            this.openDirectoryButton.TabIndex = 4;
            this.openDirectoryButton.Text = "...";
            this.openDirectoryButton.UseVisualStyleBackColor = true;
            this.openDirectoryButton.Click += new System.EventHandler(this.openDirectoryButton_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Top;
            this.label1.Location = new System.Drawing.Point(20, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(80, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "Game Directory";
            // 
            // translateButton
            // 
            this.translateButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.translateButton.Location = new System.Drawing.Point(20, 480);
            this.translateButton.Name = "translateButton";
            this.translateButton.Size = new System.Drawing.Size(1367, 40);
            this.translateButton.TabIndex = 8;
            this.translateButton.Text = "Translate";
            this.translateButton.UseVisualStyleBackColor = true;
            this.translateButton.Click += new System.EventHandler(this.translateButton_Click);
            // 
            // cachedTranslationLabel
            // 
            this.cachedTranslationLabel.AutoSize = true;
            this.cachedTranslationLabel.Location = new System.Drawing.Point(0, 7);
            this.cachedTranslationLabel.Name = "cachedTranslationLabel";
            this.cachedTranslationLabel.Size = new System.Drawing.Size(110, 13);
            this.cachedTranslationLabel.TabIndex = 9;
            this.cachedTranslationLabel.Text = "Cached Translations: ";
            // 
            // editTranslationsButton
            // 
            this.editTranslationsButton.Location = new System.Drawing.Point(163, 2);
            this.editTranslationsButton.Name = "editTranslationsButton";
            this.editTranslationsButton.Size = new System.Drawing.Size(127, 23);
            this.editTranslationsButton.TabIndex = 10;
            this.editTranslationsButton.Text = "Edit Translations";
            this.editTranslationsButton.UseVisualStyleBackColor = true;
            this.editTranslationsButton.Click += new System.EventHandler(this.editTranslationsButton_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.directoryTextBox);
            this.panel1.Controls.Add(this.openDirectoryButton);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(20, 41);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1367, 23);
            this.panel1.TabIndex = 12;
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.numberCachedLabel);
            this.panel2.Controls.Add(this.editTranslationsButton);
            this.panel2.Controls.Add(this.cachedTranslationLabel);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(20, 64);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(1367, 33);
            this.panel2.TabIndex = 13;
            // 
            // numberCachedLabel
            // 
            this.numberCachedLabel.AutoSize = true;
            this.numberCachedLabel.Location = new System.Drawing.Point(104, 7);
            this.numberCachedLabel.Name = "numberCachedLabel";
            this.numberCachedLabel.Size = new System.Drawing.Size(0, 13);
            this.numberCachedLabel.TabIndex = 11;
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.outputTextbox);
            this.panel3.Controls.Add(this.panel8);
            this.panel3.Controls.Add(this.label2);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel3.Location = new System.Drawing.Point(20, 97);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(1367, 383);
            this.panel3.TabIndex = 14;
            // 
            // outputTextbox
            // 
            this.outputTextbox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.outputTextbox.Location = new System.Drawing.Point(0, 22);
            this.outputTextbox.Name = "outputTextbox";
            this.outputTextbox.Size = new System.Drawing.Size(1367, 361);
            this.outputTextbox.TabIndex = 13;
            this.outputTextbox.Text = "";
            this.outputTextbox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.outputTextbox_KeyPress);
            // 
            // panel8
            // 
            this.panel8.Controls.Add(this.autoScrollCheckbox);
            this.panel8.Controls.Add(this.label4);
            this.panel8.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel8.Location = new System.Drawing.Point(0, 0);
            this.panel8.Name = "panel8";
            this.panel8.Size = new System.Drawing.Size(1367, 22);
            this.panel8.TabIndex = 14;
            // 
            // autoScrollCheckbox
            // 
            this.autoScrollCheckbox.AutoSize = true;
            this.autoScrollCheckbox.Dock = System.Windows.Forms.DockStyle.Right;
            this.autoScrollCheckbox.Location = new System.Drawing.Point(1290, 0);
            this.autoScrollCheckbox.Name = "autoScrollCheckbox";
            this.autoScrollCheckbox.Size = new System.Drawing.Size(77, 22);
            this.autoScrollCheckbox.TabIndex = 13;
            this.autoScrollCheckbox.Text = "Auto Scroll";
            this.autoScrollCheckbox.UseVisualStyleBackColor = true;
            this.autoScrollCheckbox.Visible = false;
            // 
            // label4
            // 
            this.label4.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(0, 4);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(39, 13);
            this.label4.TabIndex = 12;
            this.label4.Text = "Output";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(-163, -83);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(39, 13);
            this.label2.TabIndex = 7;
            this.label2.Text = "Output";
            // 
            // panel4
            // 
            this.panel4.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel4.Location = new System.Drawing.Point(0, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(20, 540);
            this.panel4.TabIndex = 13;
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.menuStrip1);
            this.panel5.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel5.Location = new System.Drawing.Point(20, 0);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(1367, 28);
            this.panel5.TabIndex = 15;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.settingsToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1367, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // settingsToolStripMenuItem
            // 
            this.settingsToolStripMenuItem.Name = "settingsToolStripMenuItem";
            this.settingsToolStripMenuItem.Size = new System.Drawing.Size(61, 20);
            this.settingsToolStripMenuItem.Text = "Settings";
            this.settingsToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // panel6
            // 
            this.panel6.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel6.Location = new System.Drawing.Point(1387, 0);
            this.panel6.Name = "panel6";
            this.panel6.Size = new System.Drawing.Size(20, 540);
            this.panel6.TabIndex = 16;
            // 
            // panel7
            // 
            this.panel7.Controls.Add(this.progressBar);
            this.panel7.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel7.Location = new System.Drawing.Point(20, 520);
            this.panel7.Name = "panel7";
            this.panel7.Size = new System.Drawing.Size(1367, 20);
            this.panel7.TabIndex = 17;
            // 
            // progressBar
            // 
            this.progressBar.Dock = System.Windows.Forms.DockStyle.Fill;
            this.progressBar.Location = new System.Drawing.Point(0, 0);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(1367, 20);
            this.progressBar.TabIndex = 14;
            // 
            // RPGTranslator
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1407, 540);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.translateButton);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel5);
            this.Controls.Add(this.panel7);
            this.Controls.Add(this.panel6);
            this.Controls.Add(this.panel4);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "RPGTranslator";
            this.Text = "RPG Maker Translator";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.RPGTranslator_FormClosing);
            this.Load += new System.EventHandler(this.RPGTranslator_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.panel8.ResumeLayout(false);
            this.panel8.PerformLayout();
            this.panel5.ResumeLayout(false);
            this.panel5.PerformLayout();
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.panel7.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.TextBox directoryTextBox;
        private System.Windows.Forms.Button openDirectoryButton;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button translateButton;
        private System.Windows.Forms.Label cachedTranslationLabel;
        private System.Windows.Forms.Button editTranslationsButton;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.Panel panel6;
        private System.Windows.Forms.Panel panel7;
        private System.Windows.Forms.Label numberCachedLabel;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem settingsToolStripMenuItem;
        private System.Windows.Forms.RichTextBox outputTextbox;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Panel panel8;
        private System.Windows.Forms.CheckBox autoScrollCheckbox;
    }
}

