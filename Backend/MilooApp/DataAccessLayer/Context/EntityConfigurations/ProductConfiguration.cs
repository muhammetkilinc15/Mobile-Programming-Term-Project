using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Context.EntityConfigurations
{
    public class ProductConfiguration : BaseEntityConfiguration<Product>
    {
        public override void Configure(EntityTypeBuilder<Product> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.Title).IsRequired().HasMaxLength(200);
            builder.Property(x => x.Description).IsRequired().HasMaxLength(500);
            builder.Property(x => x.Price).HasColumnType("decimal(18,2)");
            builder.Property(builder => builder.IsDeleted).HasDefaultValue(false);
            builder.Property(builder => builder.CreatedAt).HasDefaultValueSql("GETDATE()");
            builder.HasOne(x => x.SubCategory).WithMany(x => x.Listings).HasForeignKey(x => x.SubCategoryId).OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(x => x.Publisher).WithMany(x => x.Products).HasForeignKey(x => x.PublisherId).OnDelete(DeleteBehavior.Cascade);
            builder.HasMany(x => x.Images).WithOne(x => x.Product).HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Cascade);


            builder.HasIndex(x => x.Title);
            builder.HasIndex(x => x.Price);


            builder.HasMany(builder => builder.Images).WithOne(builder => builder.Product).HasForeignKey(builder => builder.ProductId).OnDelete(DeleteBehavior.Cascade);
            builder.HasMany(builder => builder.UserFavoriteProducts).WithOne(builder => builder.Product).HasForeignKey(builder => builder.ProductId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}
