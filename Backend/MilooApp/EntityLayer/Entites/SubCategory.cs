using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class SubCategory : BaseEntity
    {
        public string Name { get; set; }
        public int CategoryId { get; set; }
        [JsonIgnore]
        public Category Category { get; set; }

        [JsonIgnore]
        public ICollection<Product> Listings { get; set; }
    }
}
