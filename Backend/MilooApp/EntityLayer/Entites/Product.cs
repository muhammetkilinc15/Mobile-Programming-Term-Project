using EntityLayer.Entites.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class Product : BaseEntity
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int Views { get; set; }
        public bool isSold { get; set; }

        [JsonIgnore]
        public int SubCategoryId { get; set; }
        [JsonIgnore]
        public SubCategory SubCategory { get; set; }
        public int PublisherId { get; set; }
        [JsonIgnore]
        public User Publisher { get; set; }
        [JsonIgnore]
        public ICollection<ProductImages> Images { get; set; }

        [JsonIgnore]
        public bool IsDeleted { get; set; }
        public DateTime CreatedAt { get; set; }


        [JsonIgnore]
        public ICollection<UserFavoriteProducts> UserFavoriteProducts { get; set; }
    }
}
