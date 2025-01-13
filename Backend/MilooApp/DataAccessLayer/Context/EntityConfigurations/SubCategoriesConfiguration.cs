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
    public class SubCategoriesConfiguration : BaseEntityConfiguration<SubCategory>
    {
        public override void Configure(EntityTypeBuilder<SubCategory> builder)
        {
            base.Configure(builder);
            builder.Property(x => x.Name).IsRequired().HasMaxLength(100);
            builder.HasIndex(x => x.Name).IsUnique();

            builder.HasOne(x=>x.Category).WithMany(x => x.SubCategories).HasForeignKey(x => x.CategoryId).OnDelete(DeleteBehavior.Cascade);

            builder.HasMany(x => x.Listings).WithOne(x => x.SubCategory).HasForeignKey(x => x.SubCategoryId).OnDelete(DeleteBehavior.Cascade);
        }
    }
}
