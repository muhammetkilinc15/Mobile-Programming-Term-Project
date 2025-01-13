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
    public class MessageFileConfiguration : BaseEntityConfiguration<MessageFiles>
    {
        public override void Configure(EntityTypeBuilder<MessageFiles> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.FilePath).IsRequired().HasMaxLength(600).HasColumnType("VARCHAR");
        }
    }
}
