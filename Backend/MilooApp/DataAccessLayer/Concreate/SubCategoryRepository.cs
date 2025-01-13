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
    public class SubCategoryRepository : GenericRepository<SubCategory>, ISubCategoryRepository
    {
        public SubCategoryRepository(ApplicationDbContext context) : base(context)
        {
        }
    }
}
