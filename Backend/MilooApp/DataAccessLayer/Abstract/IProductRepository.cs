using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Abstract
{
    public interface IProductRepository : IGenericRepository<Product>
    {
        Task<bool> AddOrDeleteFavoriteProduct(int userId, int productId);
        Task<bool> IsFavorite(int userId, int productId);
    }
}
