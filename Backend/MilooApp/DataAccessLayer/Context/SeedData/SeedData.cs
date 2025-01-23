using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer.Context.SeedData
{
    public static class SeedData
    {
        public static void Seed(ModelBuilder builder)
        {

            builder.Entity<User>().HasData(
                new User
                {
                    Id = 1,
                    FirstName = "Muhammet",
                    LastName = "Kılınç",
                    UserName = "muhammetkilinc",
                    Email = "210129049@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                    IsEmailVerified = true,
                },
                new User
                {
                    Id = 2,
                    FirstName = "Beyza",
                    LastName = "Kılınç",
                    UserName = "beyza",
                    Email = "210129001@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                },
                new User
                {
                    Id = 3,
                    FirstName = "Osman",
                    LastName = "Kaya",
                    UserName = "osmankaya",
                    Email = "210129002@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                },
                new User
                {
                    Id = 4,
                    FirstName = "Mehmet",
                    LastName = "Ulutaş",
                    UserName = "mehmetulutas",
                    Email = "mehmet@gmail.com",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                },
                new User
                {
                    Id = 5,
                    FirstName = "Ali",
                    LastName = "Kaya",
                    UserName = "alikaya",
                    Email = "210129003@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                },
                new User
                {
                    Id = 6,
                    FirstName = "Veli",
                    LastName = "Kaya",
                    UserName = "velikaya",
                    Email = "210129004@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 1,
                },
                 new User
                 {
                     Id = 7,
                     FirstName = "Tarık",
                     LastName = "köklü",
                     UserName = "tarikkoklu",
                     Email = "210129005@ogr.atu.edu.tr",
                     PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                     UniversityId = 2,
                 },
                new User
                {
                    Id = 8,
                    FirstName = "Ayse",
                    LastName = "Bozkurt",
                    UserName = "aysebzkrt",
                    Email = "210129006@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 2,
                },

                new User
                {
                    Id = 9,
                    FirstName = "Ceren",
                    LastName = "Tokgöz",
                    UserName = "cerentkgz",
                    Email = "210129007@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 2,
                },
                new User
                {
                    Id = 10,
                    FirstName = "Kayra",
                    LastName = "Kabakcioglu",
                    UserName = "kayra",
                    Email = "210129008@ogr.stu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 2,
                },
                new User
                {
                    Id = 11,
                    FirstName = "Ugur",
                    LastName = "Tansal",
                    UserName = "ugurtansal",
                    Email = "210129053@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 7,
                },
                new User
                {
                    Id = 12,
                    FirstName = "Batuhan",
                    LastName = "Özsürmeli",
                    UserName = "batuozsurmeli",
                    Email = "210129009@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 7,
                },
                new User
                {
                    Id = 13,
                    FirstName = "Raziye",
                    LastName = "Kök",
                    UserName = "raziye",
                    Email = "210129011@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 7,
                },
                new User
                {
                    Id = 14,
                    FirstName = "Mustafa",
                    LastName = "Acikkar",
                    UserName = "mustafaacikkar",
                    Email = "210129013@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 7,

                },
                new User
                {
                    Id = 15,
                    FirstName = "Yavuz",
                    LastName = "Akkoç",
                    UserName = "beyzaakkoc",
                    Email = "210129014@ogr.atu.edu.tr",
                    PasswordHash = "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC",
                    UniversityId = 7,
                }
                );


            builder.Entity<Role>().HasData(
                new Role { Id = 1, Name = "Admin" },
                new Role { Id = 2, Name = "User" },
                new Role { Id = 3, Name = "Seller" }
                );

            builder.Entity<UserRole>().HasData(
                 new UserRole { Id = 1, UserId = 1, RoleId = 1 },
                 new UserRole { Id = 2, UserId = 2, RoleId = 2 },
                 new UserRole { Id = 3, UserId = 3, RoleId = 2 },
                 new UserRole { Id = 4, UserId = 4, RoleId = 2 },
                 new UserRole { Id = 5, UserId = 5, RoleId = 2 },
                 new UserRole { Id = 6, UserId = 6, RoleId = 2 },
                 new UserRole { Id = 7, UserId = 7, RoleId = 2 },
                 new UserRole { Id = 8, UserId = 8, RoleId = 2 },
                 new UserRole { Id = 9, UserId = 9, RoleId = 2 },
                 new UserRole { Id = 10, UserId = 10, RoleId = 2 },
                 new UserRole { Id = 11, UserId = 11, RoleId = 2 },
                 new UserRole { Id = 12, UserId = 12, RoleId = 2 },
                 new UserRole { Id = 13, UserId = 13, RoleId = 2 },
                 new UserRole { Id = 14, UserId = 14, RoleId = 2 },
                 new UserRole { Id = 15, UserId = 15, RoleId = 2 }
            );

            builder.Entity<UserPhoto>().HasData(
                new UserPhoto { Id = 1, UserId = 1, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 2, UserId = 2, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 3, UserId = 3, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 4, UserId = 4, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 5, UserId = 5, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 6, UserId = 6, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 7, UserId = 7, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 8, UserId = 8, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 9, UserId = 9, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 10, UserId = 10, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 11, UserId = 11, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 12, UserId = 12, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 13, UserId = 13, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 14, UserId = 14, ImagePath = "default-profile.png" },
                new UserPhoto { Id = 15, UserId = 15, ImagePath = "default-profile.png" }

            );


            builder.Entity<Message>().HasData(
              new Message() { Id = 1, SenderId = 1, ReceiverId = 2, MessageText = "Merhaba iyi günler, ürünü kaç tl ye satıyorsunuz", IsRead = true, SentOn = DateTime.Now, }
            );



            builder.Entity<Category>().HasData(
                new Category { Id = 1, Name = "Electronics" },
                new Category { Id = 2, Name = "Books" },
                new Category { Id = 3, Name = "Games" },
                new Category { Id = 4, Name = "Clothes" },
                new Category { Id = 5, Name = "Shoes" },
                new Category { Id = 6, Name = "Toys" }

             );

            builder.Entity<SubCategory>().HasData(
                new SubCategory { Id = 1, Name = "Mobile", CategoryId = 1 },
                new SubCategory { Id = 2, Name = "Laptop", CategoryId = 1 },
                new SubCategory { Id = 3, Name = "Tablet", CategoryId = 1 },
                new SubCategory { Id = 12, Name = "Calculator", CategoryId = 1 },
                new SubCategory { Id = 4, Name = "Novel", CategoryId = 2 },
                new SubCategory { Id = 5, Name = "Comic", CategoryId = 2 },
                new SubCategory { Id = 6, Name = "Action", CategoryId = 3 },
                new SubCategory { Id = 7, Name = "Adventure", CategoryId = 3 },
                new SubCategory { Id = 8, Name = "Shirt", CategoryId = 4 },
                new SubCategory { Id = 9, Name = "Pants", CategoryId = 4 },
                new SubCategory { Id = 10, Name = "Sneakers", CategoryId = 5 },
                new SubCategory { Id = 11, Name = "Boots", CategoryId = 5 },
                new SubCategory { Id = 13, Name = "Sandal", CategoryId = 5 },
                new SubCategory { Id = 14, Name = "Slipper", CategoryId = 5 },
                new SubCategory { Id = 15, Name = "Shorts", CategoryId = 4 },
                new SubCategory { Id = 16, Name = "T-shirt", CategoryId = 4 }
            );

            builder.Entity<University>().HasData(
                new University { Id = 1, Name = "Adana Alparslan Türkeş Bilim Ve Teknoloji Üniversitesi" },
                new University { Id = 2, Name = "Adıyaman Üniversitesi" },
                new University { Id = 3, Name = "Afyon Kocatepe Üniversitesi" },
                new University { Id = 4, Name = "Ağrı İbrahim Çeçen Üniversitesi" },
                new University { Id = 5, Name = "Ahi Evran Üniversitesi" },
                new University { Id = 6, Name = "Aksaray Üniversitesi" },
                new University { Id = 7, Name = "Amasya Üniversitesi" },
                new University { Id = 8, Name = "Anadolu Üniversitesi" },
                new University { Id = 9, Name = "Ankara Hacı Bayram Veli Üniversitesi" },
                new University { Id = 10, Name = "Ankara Üniversitesi" },
                new University { Id = 11, Name = "Ardahan Üniversitesi" },
                new University { Id = 12, Name = "Artvin Çoruh Üniversitesi" },
                new University { Id = 13, Name = "Atatürk Üniversitesi" },
                new University { Id = 14, Name = "Balıkesir Üniversitesi" },
                new University { Id = 15, Name = "Bartın Üniversitesi" },
                new University { Id = 16, Name = "Batman Üniversitesi" },
                new University { Id = 17, Name = "Bayburt Üniversitesi" },
                new University { Id = 18, Name = "Bilecik Şeyh Edebali Üniversitesi" },
                new University { Id = 19, Name = "Bingöl Üniversitesi" },
                new University { Id = 20, Name = "Bitlis Eren Üniversitesi" },
                new University { Id = 21, Name = "Boğaziçi Üniversitesi" },
                new University { Id = 22, Name = "Bozok Üniversitesi" },
                new University { Id = 23, Name = "Bülent Ecevit Üniversitesi" },
                new University { Id = 24, Name = "Celal Bayar Üniversitesi" },
                new University { Id = 25, Name = "Cumhuriyet Üniversitesi" },
                new University { Id = 26, Name = "Çanakkale Onsekiz Mart Üniversitesi" },
                new University { Id = 27, Name = "Çankırı Karatekin Üniversitesi" },
                new University { Id = 28, Name = "Çukurova Üniversitesi" },
                new University { Id = 29, Name = "Deniz Harp Okulu" },
                new University { Id = 30, Name = "Dicle Üniversitesi" },
                new University { Id = 31, Name = "Dokuz Eylül Üniversitesi" },
                new University { Id = 32, Name = "Dumlupınar Üniversitesi" },
                new University { Id = 33, Name = "Düzce Üniversitesi" },
                new University { Id = 34, Name = "Ege Üniversitesi" },
                new University { Id = 35, Name = "Erciyes Üniversitesi" },
                new University { Id = 36, Name = "Erzincan Binali Yıldırım Üniversitesi" },
                new University { Id = 37, Name = "Erzurum Teknik Üniversitesi" },
                new University { Id = 38, Name = "Eskişehir Osmangazi Üniversitesi" },
                new University { Id = 39, Name = "Fırat Üniversitesi" },
                new University { Id = 40, Name = "Galatasaray Üniversitesi" },
                new University { Id = 41, Name = "Gazi Üniversitesi" },
                new University { Id = 42, Name = "Gaziantep Üniversitesi" },
                new University { Id = 43, Name = "Gaziosmanpaşa Üniversitesi" },
                new University { Id = 44, Name = "Gebze Teknik Üniversitesi" },
                new University { Id = 45, Name = "Giresun Üniversitesi" },
                new University { Id = 46, Name = "Gümüşhane Üniversitesi" },
                new University { Id = 47, Name = "Hacettepe Üniversitesi" },
                new University { Id = 48, Name = "Hakkari Üniversitesi" },
                new University { Id = 49, Name = "Harran Üniversitesi" },
                new University { Id = 50, Name = "Hitit Üniversitesi" },
                new University { Id = 51, Name = "Iğdır Üniversitesi" },
                new University { Id = 52, Name = "İnönü Üniversitesi" },
                new University { Id = 53, Name = "İskenderun Teknik Üniversitesi" },
                new University { Id = 54, Name = "İstanbul Medeniyet Üniversitesi" },
                new University { Id = 55, Name = "İstanbul Teknik Üniversitesi" },
                new University { Id = 56, Name = "İstanbul Üniversitesi" },
                new University { Id = 57, Name = "İzmir Bakırçay Üniversitesi" },
                new University { Id = 58, Name = "İzmir Demokrasi Üniversitesi" },
                new University { Id = 59, Name = "İzmir Kâtip Çelebi Üniversitesi" },
                new University { Id = 60, Name = "İzmir Yüksek Teknoloji Enstitüsü" },
                new University { Id = 61, Name = "Kafkas Üniversitesi" },
                new University { Id = 62, Name = "Kahramanmaraş Sütçü İmam Üniversitesi" },
                new University { Id = 63, Name = "Karabük Üniversitesi" },
                new University { Id = 64, Name = "Karadeniz Teknik Üniversitesi" },
                new University { Id = 65, Name = "Karamanoğlu Mehmetbey Üniversitesi" },
                new University { Id = 66, Name = "Kastamonu Üniversitesi" },
                new University { Id = 67, Name = "Kırıkkale Üniversitesi" },
                new University { Id = 68, Name = "Kırklareli Üniversitesi" },
                new University { Id = 69, Name = "Kırşehir Ahi Evran Üniversitesi" },
                new University { Id = 70, Name = "Kilis 7 Aralık Üniversitesi" },
                new University { Id = 71, Name = "Kocaeli Üniversitesi" },
                new University { Id = 72, Name = "Konya Gıda ve Tarım Üniversitesi" },
                new University { Id = 73, Name = "KTO Karatay Üniversitesi" },
                new University { Id = 74, Name = "Maltepe Üniversitesi" },
                new University { Id = 75, Name = "Mardin Artuklu Üniversitesi" },
                new University { Id = 76, Name = "Marmara Üniversitesi" },
                new University { Id = 77, Name = "Mehmet Akif Ersoy Üniversitesi" },
                new University { Id = 78, Name = "Mersin Üniversitesi" },
                new University { Id = 79, Name = "Mimar Sinan Güzel Sanatlar Üniversitesi" },
                new University { Id = 80, Name = "Muğla Sıtkı Koçman Üniversitesi" },
                new University { Id = 81, Name = "Muş Alparslan Üniversitesi" },
                new University { Id = 82, Name = "Mustafa Kemal Üniversitesi" },
                new University { Id = 83, Name = "Namık Kemal Üniversitesi" },
                new University { Id = 84, Name = "Necmettin Erbakan Üniversitesi" },
                new University { Id = 85, Name = "Nevşehir Hacı Bektaş Veli Üniversitesi" },
                new University { Id = 86, Name = "Niğde Ömer Halisdemir Üniversitesi" },
                new University { Id = 87, Name = "Ordu Üniversitesi" },
                new University { Id = 88, Name = "Orta Doğu Teknik Üniversitesi" },
                new University { Id = 89, Name = "Osmaniye Korkut Ata Üniversitesi" },
                new University { Id = 90, Name = "Ömer Halisdemir Üniversitesi" },
                new University { Id = 91, Name = "Pamukkale Üniversitesi" },
                new University { Id = 92, Name = "Polis Akademisi" },
                new University { Id = 93, Name = "Recep Tayyip Erdoğan Üniversitesi" },
                new University { Id = 94, Name = "Sakarya Üniversitesi" },
                new University { Id = 95, Name = "Selçuk Üniversitesi" },
                new University { Id = 96, Name = "Siirt Üniversitesi" },
                new University { Id = 97, Name = "Sinop Üniversitesi" },
                new University { Id = 98, Name = "Süleyman Demirel Üniversitesi" },
                new University { Id = 99, Name = "Şırnak Üniversitesi" },
                new University { Id = 100, Name = "Trakya Üniversitesi" },
                new University { Id = 101, Name = "Tunceli Üniversitesi" },
                new University { Id = 102, Name = "Türk-Alman Üniversitesi" },
                new University { Id = 103, Name = "Türk Hava Kurumu Üniversitesi" },
                new University { Id = 104, Name = "Türkiye Uluslararası İslam, Bilim ve Teknoloji Üniversitesi" },
                new University { Id = 105, Name = "Uşak Üniversitesi" },
                new University { Id = 106, Name = "Üsküdar Üniversitesi" },
                new University { Id = 107, Name = "Van Yüzüncü Yıl Üniversitesi" },
                new University { Id = 108, Name = "Yalova Üniversitesi" },
                new University { Id = 109, Name = "Yıldız Teknik Üniversitesi" },
                new University { Id = 110, Name = "Yıldırım Beyazıt Üniversitesi" },
                new University { Id = 111, Name = "Yüzüncü Yıl Üniversitesi" },
                new University { Id = 112, Name = "Zonguldak Bülent Ecevit Üniversitesi" }
              );
           
        }
    }
}
