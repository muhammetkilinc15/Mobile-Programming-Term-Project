using DataAccessLayer.Context.SeedData;
using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Context
{
    public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : DbContext(options)
    {


        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .ConfigureWarnings(warnings =>
                    warnings.Ignore(RelationalEventId.PendingModelChangesWarning));
        }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // we can execute all the entries instead of define by one by
            modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
           SeedData.SeedData.Seed(modelBuilder);
        }

        public DbSet<User> Users { get; set; }
        public DbSet<UserPhoto> UserPhotos { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<UserFavoriteProducts> UserFavoriteProducts { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<SubCategory> SubCategories { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<ProductImages> ProductImages { get; set; }
        public DbSet<University> Universities { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<MessageFiles> MessageFiles { get; set; }

    }
}
