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
    public class MessageConfiguration : BaseEntityConfiguration<Message>
    {
        public override void Configure(EntityTypeBuilder<Message> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.MessageText).IsRequired().HasMaxLength(200);
            builder.Property(x => x.SenderId).IsRequired();
            builder.Property(x => x.ReceiverId).IsRequired();
            builder.Property(x => x.IsRead).HasDefaultValue(false);
            builder.Property(x => x.SentOn).HasDefaultValueSql("GETDATE()");

            builder.HasOne(x => x.Sender).WithMany(x => x.SentMessages).HasForeignKey(x => x.SenderId).OnDelete(DeleteBehavior.Cascade);
            builder.HasOne(x => x.Receiver).WithMany(x => x.ReceivedMessages).HasForeignKey(x => x.ReceiverId).OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(x => x.MessageFiles).WithOne(x => x.Message).HasForeignKey(x => x.MessageId).OnDelete(DeleteBehavior.Restrict);
        }
    }
}
