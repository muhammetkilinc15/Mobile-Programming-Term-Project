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
    public class UserPhotoConfiguration : BaseEntityConfiguration<UserPhoto>
    {
        public override void Configure(EntityTypeBuilder<UserPhoto> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.ImagePath).HasMaxLength(500).IsRequired().HasColumnType("VARCHAR");
            builder.Property(x => x.UserId).IsRequired(true);

        }
    }
}
