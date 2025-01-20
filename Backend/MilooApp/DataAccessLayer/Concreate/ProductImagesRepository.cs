using DataAccessLayer.Abstract;
using DataAccessLayer.Context;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Concreate
{
    public class ProductImagesRepository : GenericRepository<ProductImages>, IListingImagesRepository
    {
        public ProductImagesRepository(ApplicationDbContext context) : base(context)
        {
        }
    }
}
