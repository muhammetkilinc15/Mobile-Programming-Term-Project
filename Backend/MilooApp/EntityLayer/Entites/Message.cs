using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class Message : BaseEntity
    {
        public int SenderId { get; set; }
        [JsonIgnore]
        public User Sender { get; set; }
        public int ReceiverId { get; set; }
        [JsonIgnore]
        public User Receiver { get; set; }
        public string MessageText { get; set; }
        public DateTime SentOn { get; set; }
        public bool IsRead { get; set; }
        [JsonIgnore]
        public ICollection<MessageFiles> MessageFiles { get; set; }
    }
}
