using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.ProductDtos
{
    public class FavoriProductRequest
    {
        public int UserId { get; set; }
        public int? PageSize { get; set; }
        public int? PageNumber { get; set; }

    }
}
