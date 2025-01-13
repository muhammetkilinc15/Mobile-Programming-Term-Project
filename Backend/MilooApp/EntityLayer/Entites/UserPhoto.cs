using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class UserPhoto : BaseEntity
    {
        public int UserId { get; set; }
        [JsonIgnore]
        public User User { get; set; }
        public string ImagePath { get; set; }
        public bool isProfilePhoto { get; set; }
    }
}
