using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class MessageFiles : BaseEntity
    {
        public int MessageId { get; set; }
        [JsonIgnore]
        public Message Message { get; set; }
        public string FilePath { get; set; } 
    }
}
