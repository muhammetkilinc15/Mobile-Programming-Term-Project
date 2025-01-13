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
    public class ProductImagesConfiguration : BaseEntityConfiguration<ProductImages>
    {
        public override void Configure(EntityTypeBuilder<ProductImages> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.ImagePath).IsRequired().HasMaxLength(600).HasColumnType("VARCHAR");
            builder.HasOne(x => x.Product).WithMany(x => x.Images).HasForeignKey(x => x.ProductId).OnDelete(DeleteBehavior.Cascade);

        }
    }
}
