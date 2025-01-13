using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class Category : BaseEntity
    {
        public string Name { get; set; }

        [JsonIgnore]
        public  ICollection<SubCategory> SubCategories { get; set; }
    }
}
