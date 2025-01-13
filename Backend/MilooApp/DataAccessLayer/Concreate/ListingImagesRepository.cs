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
    public class ListingImagesRepository : GenericRepository<ProductImages>, IListingImagesRepository
    {
        public ListingImagesRepository(ApplicationDbContext context) : base(context)
        {
        }
    }
}
