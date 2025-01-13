using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.CategoryDtos
{
    public record BaseCategoryRequest : BaseRequest
    {
        public int CategoryId { get; set; }
    }
}
