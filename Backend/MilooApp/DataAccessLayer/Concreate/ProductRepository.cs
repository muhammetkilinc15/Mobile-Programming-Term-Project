using DataAccessLayer.Abstract;
using DataAccessLayer.Context;
using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Concreate
{
    public class ProductRepository : GenericRepository<Product>, IProductRepository
    {
        public ProductRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<bool> AddOrDeleteFavoriteProduct(int userId, int productId)
        {
            var userFavorite = await _context.UserFavoriteProducts
                .FirstOrDefaultAsync(uf => uf.UserId == userId && uf.ProductId == productId);

            if (userFavorite == null)
            {
                // Favori ürünü ekleme
                await _context.UserFavoriteProducts.AddAsync(new UserFavoriteProducts
                {
                    UserId = userId,
                    ProductId = productId,
                    Status = true // Yeni eklenen ürün favori olarak işaretlenir
                });
            }
            else
            {
                userFavorite.Status = !userFavorite.Status;
                _context.UserFavoriteProducts.Update(userFavorite);

            }

            // Değişiklikleri kaydet ve etkilenen satır sayısını kontrol et
            var changes = await _context.SaveChangesAsync();
            return changes > 0;
        }



        public async Task<bool> IsFavorite(int userId, int productId)
        {
            return await _context.UserFavoriteProducts
                .AnyAsync(x => x.Status && x.UserId == userId && x.ProductId == productId);
        }
    }
}
