using EntityLayer.Entites;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.ProductDtos
{
    public class CreateProductRequest
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public int SubCategoryId { get; set; }
        public int PublisherId { get; set; }
        public List<IFormFile> Images { get; set; }

    }

}
