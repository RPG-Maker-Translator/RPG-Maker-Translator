using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RPGMakerTranslator
{
    public class TranslationChange
    {
        public enum ChangeTypeEnum { DELETE = 0, UPDATE }
        
        public ChangeTypeEnum ChangeType { get; set; }
        public string Source { get; set; }
        public string Translation { get; set; }
        public string NewValue { get; set; }

        public override bool Equals(object obj)
        {
            if (Object.ReferenceEquals(obj, this))
            { 
                return true;
            }

            TranslationChange other = obj as TranslationChange;
            if (Object.ReferenceEquals(null, other))
            { 
                return false;
            }

            if (Object.ReferenceEquals(Source, other.Source))
            {
                return true;
            }
            else if (Object.ReferenceEquals(Source, null) || Object.ReferenceEquals(other.Source, null))
            {
                return false;
            }

            return String.Equals(Source, Source, StringComparison.Ordinal);
        }

        public override int GetHashCode()
        {
            if (Object.ReferenceEquals(null, Source))
            { 
                return 0;
            }

            return Source.GetHashCode();
        }
    }
}
