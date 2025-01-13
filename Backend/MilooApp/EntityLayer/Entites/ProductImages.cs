using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class ProductImages : BaseEntity
    {
        public int ProductId { get; set; }
        public string ImagePath { get; set; }
        [JsonIgnore]
        public Product Product { get; set; }
    }
}
