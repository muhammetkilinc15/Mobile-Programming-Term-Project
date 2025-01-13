using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.ProductDtos
{
    public record BaseProductRequestDto : BaseRequest
    {
        public int UniversityId { get; set; }
        public int CategoryId { get; set; } = -1;
        public int SubCategoryId { get; set; } = -1;
    }
}
