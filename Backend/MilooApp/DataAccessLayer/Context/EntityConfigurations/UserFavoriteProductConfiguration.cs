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
    public class UserFavoriteProductConfiguration : BaseEntityConfiguration<UserFavoriteProducts>
    {
        public override void Configure(EntityTypeBuilder<UserFavoriteProducts> builder)
        {
            base.Configure(builder);
            builder.Property(x => x.UserId).IsRequired();
            builder.Property(x => x.ProductId).IsRequired();

            builder.HasIndex(x=>x.UserId);
            builder.HasIndex(x => x.ProductId);

            builder.HasOne(x => x.User)
                 .WithMany(x => x.UserFavoriteProducts)
                 .HasForeignKey(x => x.UserId)
                 .OnDelete(DeleteBehavior.NoAction); // ON DELETE CASCADE yerine NO ACTION kullanıyoruz.

            builder.HasOne(x => x.Product)
                .WithMany(x => x.UserFavoriteProducts)
                .HasForeignKey(x => x.ProductId)
                .OnDelete(DeleteBehavior.Cascade); // ON DELETE CASCADE yerine NO ACTION kullanıyoruz.


        }
    }
}
