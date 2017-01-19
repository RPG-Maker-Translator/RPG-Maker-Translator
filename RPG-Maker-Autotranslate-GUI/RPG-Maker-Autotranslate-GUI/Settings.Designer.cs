namespace RPGMakerTranslator
{
    partial class Settings
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Settings));
            this.label2 = new System.Windows.Forms.Label();
            this.showTranslationCheckbox = new System.Windows.Forms.CheckBox();
            this.saveButton = new System.Windows.Forms.Button();
            this.outputDirectoryTextBox = new System.Windows.Forms.TextBox();
            this.chooseDirectoryButton = new System.Windows.Forms.Button();
            this.skipDataExtractCheckbox = new System.Windows.Forms.CheckBox();
            this.skipJsonDumpCheckbox = new System.Windows.Forms.CheckBox();
            this.skipTranslateCheckbox = new System.Windows.Forms.CheckBox();
            this.deleteExistingCheckbox = new System.Windows.Forms.CheckBox();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.translateFromCacheOnlyCheckbox = new System.Windows.Forms.CheckBox();
            this.logCacheHitsCheckbox = new System.Windows.Forms.CheckBox();
            this.logTranslationsCheckbox = new System.Windows.Forms.CheckBox();
            this.breakBlocksOnKatakanaCheckbox = new System.Windows.Forms.CheckBox();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.allFiltersComboBox = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.outputLanguageComboBox = new System.Windows.Forms.ComboBox();
            this.translateScriptsCheckbox = new System.Windows.Forms.CheckBox();
            this.translateLinesWithVars = new System.Windows.Forms.CheckBox();
            this.label4 = new System.Windows.Forms.Label();
            this.characterOverrideTextbox = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(55, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Output Dir";
            // 
            // showTranslationCheckbox
            // 
            this.showTranslationCheckbox.AutoSize = true;
            this.showTranslationCheckbox.Checked = true;
            this.showTranslationCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.showTranslationCheckbox.Location = new System.Drawing.Point(15, 48);
            this.showTranslationCheckbox.Name = "showTranslationCheckbox";
            this.showTranslationCheckbox.Size = new System.Drawing.Size(143, 17);
            this.showTranslationCheckbox.TabIndex = 4;
            this.showTranslationCheckbox.Text = "Show Translation Output";
            this.showTranslationCheckbox.UseVisualStyleBackColor = true;
            // 
            // saveButton
            // 
            this.saveButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.saveButton.Location = new System.Drawing.Point(0, 548);
            this.saveButton.Name = "saveButton";
            this.saveButton.Size = new System.Drawing.Size(527, 23);
            this.saveButton.TabIndex = 5;
            this.saveButton.Text = "Save";
            this.saveButton.UseVisualStyleBackColor = true;
            this.saveButton.Click += new System.EventHandler(this.saveButton_Click);
            // 
            // outputDirectoryTextBox
            // 
            this.outputDirectoryTextBox.Location = new System.Drawing.Point(73, 10);
            this.outputDirectoryTextBox.Name = "outputDirectoryTextBox";
            this.outputDirectoryTextBox.Size = new System.Drawing.Size(379, 20);
            this.outputDirectoryTextBox.TabIndex = 6;
            // 
            // chooseDirectoryButton
            // 
            this.chooseDirectoryButton.Location = new System.Drawing.Point(458, 8);
            this.chooseDirectoryButton.Name = "chooseDirectoryButton";
            this.chooseDirectoryButton.Size = new System.Drawing.Size(31, 23);
            this.chooseDirectoryButton.TabIndex = 7;
            this.chooseDirectoryButton.Text = "...";
            this.chooseDirectoryButton.UseVisualStyleBackColor = true;
            this.chooseDirectoryButton.Click += new System.EventHandler(this.chooseDirectoryButton_Click);
            // 
            // skipDataExtractCheckbox
            // 
            this.skipDataExtractCheckbox.AutoSize = true;
            this.skipDataExtractCheckbox.Location = new System.Drawing.Point(15, 116);
            this.skipDataExtractCheckbox.Name = "skipDataExtractCheckbox";
            this.skipDataExtractCheckbox.Size = new System.Drawing.Size(180, 17);
            this.skipDataExtractCheckbox.TabIndex = 8;
            this.skipDataExtractCheckbox.Text = "Skip Extract From Main Data File";
            this.skipDataExtractCheckbox.UseVisualStyleBackColor = true;
            // 
            // skipJsonDumpCheckbox
            // 
            this.skipJsonDumpCheckbox.AutoSize = true;
            this.skipJsonDumpCheckbox.Location = new System.Drawing.Point(15, 139);
            this.skipJsonDumpCheckbox.Name = "skipJsonDumpCheckbox";
            this.skipJsonDumpCheckbox.Size = new System.Drawing.Size(185, 17);
            this.skipJsonDumpCheckbox.TabIndex = 9;
            this.skipJsonDumpCheckbox.Text = "Skip JSON Dump From Data Files";
            this.skipJsonDumpCheckbox.UseVisualStyleBackColor = true;
            // 
            // skipTranslateCheckbox
            // 
            this.skipTranslateCheckbox.AutoSize = true;
            this.skipTranslateCheckbox.Location = new System.Drawing.Point(15, 162);
            this.skipTranslateCheckbox.Name = "skipTranslateCheckbox";
            this.skipTranslateCheckbox.Size = new System.Drawing.Size(175, 17);
            this.skipTranslateCheckbox.TabIndex = 10;
            this.skipTranslateCheckbox.Text = "Skip Translate From JSON Files";
            this.skipTranslateCheckbox.UseVisualStyleBackColor = true;
            // 
            // deleteExistingCheckbox
            // 
            this.deleteExistingCheckbox.AutoSize = true;
            this.deleteExistingCheckbox.Checked = true;
            this.deleteExistingCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.deleteExistingCheckbox.Location = new System.Drawing.Point(15, 94);
            this.deleteExistingCheckbox.Name = "deleteExistingCheckbox";
            this.deleteExistingCheckbox.Size = new System.Drawing.Size(249, 17);
            this.deleteExistingCheckbox.TabIndex = 11;
            this.deleteExistingCheckbox.Text = "Delete Existing Output Directory Before Starting";
            this.deleteExistingCheckbox.UseVisualStyleBackColor = true;
            // 
            // translateFromCacheOnlyCheckbox
            // 
            this.translateFromCacheOnlyCheckbox.AutoSize = true;
            this.translateFromCacheOnlyCheckbox.Location = new System.Drawing.Point(15, 71);
            this.translateFromCacheOnlyCheckbox.Name = "translateFromCacheOnlyCheckbox";
            this.translateFromCacheOnlyCheckbox.Size = new System.Drawing.Size(154, 17);
            this.translateFromCacheOnlyCheckbox.TabIndex = 12;
            this.translateFromCacheOnlyCheckbox.Text = "Translate From Cache Only";
            this.translateFromCacheOnlyCheckbox.UseVisualStyleBackColor = true;
            // 
            // logCacheHitsCheckbox
            // 
            this.logCacheHitsCheckbox.AutoSize = true;
            this.logCacheHitsCheckbox.Location = new System.Drawing.Point(310, 94);
            this.logCacheHitsCheckbox.Name = "logCacheHitsCheckbox";
            this.logCacheHitsCheckbox.Size = new System.Drawing.Size(154, 17);
            this.logCacheHitsCheckbox.TabIndex = 13;
            this.logCacheHitsCheckbox.Text = "Log Cache Translation Hits";
            this.logCacheHitsCheckbox.UseVisualStyleBackColor = true;
            // 
            // logTranslationsCheckbox
            // 
            this.logTranslationsCheckbox.AutoSize = true;
            this.logTranslationsCheckbox.Checked = true;
            this.logTranslationsCheckbox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.logTranslationsCheckbox.Location = new System.Drawing.Point(310, 71);
            this.logTranslationsCheckbox.Name = "logTranslationsCheckbox";
            this.logTranslationsCheckbox.Size = new System.Drawing.Size(157, 17);
            this.logTranslationsCheckbox.TabIndex = 14;
            this.logTranslationsCheckbox.Text = "Log API Translation Results";
            this.logTranslationsCheckbox.UseVisualStyleBackColor = true;
            // 
            // breakBlocksOnKatakanaCheckbox
            // 
            this.breakBlocksOnKatakanaCheckbox.AutoSize = true;
            this.breakBlocksOnKatakanaCheckbox.Location = new System.Drawing.Point(310, 48);
            this.breakBlocksOnKatakanaCheckbox.Name = "breakBlocksOnKatakanaCheckbox";
            this.breakBlocksOnKatakanaCheckbox.Size = new System.Drawing.Size(215, 17);
            this.breakBlocksOnKatakanaCheckbox.TabIndex = 15;
            this.breakBlocksOnKatakanaCheckbox.Text = "Break Current Block Chain on Katakana";
            this.breakBlocksOnKatakanaCheckbox.UseVisualStyleBackColor = true;
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(0, 264);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(527, 284);
            this.flowLayoutPanel1.TabIndex = 17;
            // 
            // allFiltersComboBox
            // 
            this.allFiltersComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.allFiltersComboBox.FormattingEnabled = true;
            this.allFiltersComboBox.Location = new System.Drawing.Point(345, 231);
            this.allFiltersComboBox.Name = "allFiltersComboBox";
            this.allFiltersComboBox.Size = new System.Drawing.Size(145, 21);
            this.allFiltersComboBox.TabIndex = 18;
            this.allFiltersComboBox.SelectedIndexChanged += new System.EventHandler(this.allFiltersComboBox_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(291, 234);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(48, 13);
            this.label1.TabIndex = 19;
            this.label1.Text = "All Filters";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 234);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(90, 13);
            this.label3.TabIndex = 21;
            this.label3.Text = "Output Language";
            // 
            // outputLanguageComboBox
            // 
            this.outputLanguageComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.outputLanguageComboBox.FormattingEnabled = true;
            this.outputLanguageComboBox.Location = new System.Drawing.Point(111, 231);
            this.outputLanguageComboBox.Name = "outputLanguageComboBox";
            this.outputLanguageComboBox.Size = new System.Drawing.Size(153, 21);
            this.outputLanguageComboBox.TabIndex = 20;
            // 
            // translateScriptsCheckbox
            // 
            this.translateScriptsCheckbox.AutoSize = true;
            this.translateScriptsCheckbox.Location = new System.Drawing.Point(310, 139);
            this.translateScriptsCheckbox.Name = "translateScriptsCheckbox";
            this.translateScriptsCheckbox.Size = new System.Drawing.Size(140, 17);
            this.translateScriptsCheckbox.TabIndex = 22;
            this.translateScriptsCheckbox.Text = "Translate Scripts (Risky)";
            this.translateScriptsCheckbox.UseVisualStyleBackColor = true;
            // 
            // translateLinesWithVars
            // 
            this.translateLinesWithVars.AutoSize = true;
            this.translateLinesWithVars.Location = new System.Drawing.Point(310, 117);
            this.translateLinesWithVars.Name = "translateLinesWithVars";
            this.translateLinesWithVars.Size = new System.Drawing.Size(200, 17);
            this.translateLinesWithVars.TabIndex = 23;
            this.translateLinesWithVars.Text = "Translate Lines with variables (Risky)";
            this.translateLinesWithVars.UseVisualStyleBackColor = true;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 196);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(153, 13);
            this.label4.TabIndex = 24;
            this.label4.Text = "Honorary Japanese Characters";
            // 
            // characterOverrideTextbox
            // 
            this.characterOverrideTextbox.Location = new System.Drawing.Point(174, 193);
            this.characterOverrideTextbox.Name = "characterOverrideTextbox";
            this.characterOverrideTextbox.Size = new System.Drawing.Size(316, 20);
            this.characterOverrideTextbox.TabIndex = 25;
            this.characterOverrideTextbox.Text = "ー,";
            // 
            // Settings
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(527, 571);
            this.Controls.Add(this.characterOverrideTextbox);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.translateLinesWithVars);
            this.Controls.Add(this.translateScriptsCheckbox);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.outputLanguageComboBox);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.allFiltersComboBox);
            this.Controls.Add(this.breakBlocksOnKatakanaCheckbox);
            this.Controls.Add(this.logTranslationsCheckbox);
            this.Controls.Add(this.logCacheHitsCheckbox);
            this.Controls.Add(this.translateFromCacheOnlyCheckbox);
            this.Controls.Add(this.deleteExistingCheckbox);
            this.Controls.Add(this.skipTranslateCheckbox);
            this.Controls.Add(this.skipJsonDumpCheckbox);
            this.Controls.Add(this.skipDataExtractCheckbox);
            this.Controls.Add(this.chooseDirectoryButton);
            this.Controls.Add(this.outputDirectoryTextBox);
            this.Controls.Add(this.showTranslationCheckbox);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.flowLayoutPanel1);
            this.Controls.Add(this.saveButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Settings";
            this.Text = "Settings";
            this.Load += new System.EventHandler(this.Settings_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox showTranslationCheckbox;
        private System.Windows.Forms.Button saveButton;
        private System.Windows.Forms.TextBox outputDirectoryTextBox;
        private System.Windows.Forms.Button chooseDirectoryButton;
        private System.Windows.Forms.CheckBox skipDataExtractCheckbox;
        private System.Windows.Forms.CheckBox skipJsonDumpCheckbox;
        private System.Windows.Forms.CheckBox skipTranslateCheckbox;
        private System.Windows.Forms.CheckBox deleteExistingCheckbox;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.CheckBox translateFromCacheOnlyCheckbox;
        private System.Windows.Forms.CheckBox logCacheHitsCheckbox;
        private System.Windows.Forms.CheckBox logTranslationsCheckbox;
        private System.Windows.Forms.CheckBox breakBlocksOnKatakanaCheckbox;
        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.ComboBox allFiltersComboBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox outputLanguageComboBox;
        private System.Windows.Forms.CheckBox translateScriptsCheckbox;
        private System.Windows.Forms.CheckBox translateLinesWithVars;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox characterOverrideTextbox;
    }
}