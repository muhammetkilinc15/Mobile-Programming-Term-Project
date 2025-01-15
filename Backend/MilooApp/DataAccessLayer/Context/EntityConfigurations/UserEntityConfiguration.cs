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
    public class UserEntityConfiguration : BaseEntityConfiguration<User>
    {
        public override void Configure(EntityTypeBuilder<User> builder)
        {
            base.Configure(builder);

            builder.Property(x => x.FirstName).HasMaxLength(100).IsRequired(false);
            builder.Property(x => x.LastName).HasMaxLength(100).IsRequired(false);
            builder.Property(x => x.Email).HasMaxLength(50).IsRequired().HasColumnType("VARCHAR");
            builder.Property(x => x.UserName).HasMaxLength(50).IsRequired().HasColumnType("VARCHAR");
            builder.Property(x => x.IsEmailVerified).IsRequired(true).HasDefaultValue(false);
            builder.Property(x => x.UniversityId).IsRequired(false);
            builder.Property(x => x.IsDeleted).IsRequired(true).HasDefaultValue(false);
            builder.Property(x => x.EmailVerificationCode).IsRequired(false);


            builder.Property(x => x.EmailVerificationCodeExpiresOn).IsRequired(false).HasDefaultValueSql("GETDATE()");
            builder.Property(x => x.PasswordVerificationToken).IsRequired(false);
            builder.Property(x => x.PasswordVerificationTokenExpiresOn).IsRequired(false).HasDefaultValueSql("GETDATE()");
            builder.Property(x => x.CreatedOn).IsRequired(true).HasDefaultValueSql("GETDATE()");
            builder.Property(x => x.UpdatedOn).IsRequired(true).HasDefaultValueSql("GETDATE()");


            builder.HasIndex(x => x.Email).IsUnique();
            builder.HasIndex(x => x.UserName).IsUnique();
            


            builder.HasMany(x => x.UserPhotos).WithOne(x => x.User).HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            builder.HasMany(x => x.Products).WithOne(x => x.Publisher).HasForeignKey(x => x.PublisherId).OnDelete(DeleteBehavior.Cascade);
            builder.HasMany(x => x.SentMessages).WithOne(x => x.Sender).HasForeignKey(x => x.SenderId).OnDelete(DeleteBehavior.Restrict);
            builder.HasMany(x => x.ReceivedMessages).WithOne(x => x.Receiver).HasForeignKey(x => x.ReceiverId).OnDelete(DeleteBehavior.Restrict);
            builder.HasOne(x => x.University).WithMany(x => x.Users).HasForeignKey(x => x.UniversityId).OnDelete(DeleteBehavior.Restrict);
            builder.HasMany(x => x.UserRoles).WithOne(x => x.User).HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            builder.HasMany(x => x.UserFavoriteProducts).WithOne(x => x.User).HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
            
        }
    }
}
