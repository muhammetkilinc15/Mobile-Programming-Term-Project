using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class UserRole : BaseEntity
    {
        public int UserId { get; set; }
        [JsonIgnore]
        public User User { get; set; }
        public int RoleId { get; set; }
        [JsonIgnore]
        public Role Role { get; set; }
    }
}
