using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace DataAccessLayer.Migrations
{
    /// <inheritdoc />
    public partial class mig1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Universities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Universities", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SubCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CategoryId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubCategories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SubCategories_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Email = table.Column<string>(type: "VARCHAR(50)", maxLength: 50, nullable: false),
                    UserName = table.Column<string>(type: "VARCHAR(50)", maxLength: 50, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsEmailVerified = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    RefreshToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RefreshTokenEndDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    UniversityId = table.Column<int>(type: "int", nullable: true),
                    EmailVerificationCode = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EmailVerificationCodeExpiresOn = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "GETDATE()"),
                    PasswordVerificationToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordVerificationTokenExpiresOn = table.Column<DateTime>(type: "datetime2", nullable: true, defaultValueSql: "GETDATE()"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()"),
                    UpdatedOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()"),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Universities_UniversityId",
                        column: x => x.UniversityId,
                        principalTable: "Universities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Messages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SenderId = table.Column<int>(type: "int", nullable: false),
                    ReceiverId = table.Column<int>(type: "int", nullable: false),
                    MessageText = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    SentOn = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()"),
                    IsRead = table.Column<bool>(type: "bit", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Messages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Messages_Users_ReceiverId",
                        column: x => x.ReceiverId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Messages_Users_SenderId",
                        column: x => x.SenderId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Views = table.Column<int>(type: "int", nullable: false),
                    isSold = table.Column<bool>(type: "bit", nullable: false),
                    SubCategoryId = table.Column<int>(type: "int", nullable: false),
                    PublisherId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_SubCategories_SubCategoryId",
                        column: x => x.SubCategoryId,
                        principalTable: "SubCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Products_Users_PublisherId",
                        column: x => x.PublisherId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserPhotos",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ImagePath = table.Column<string>(type: "VARCHAR(500)", maxLength: 500, nullable: false),
                    isProfilePhoto = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserPhotos", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserPhotos_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MessageFiles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MessageId = table.Column<int>(type: "int", nullable: false),
                    FilePath = table.Column<string>(type: "VARCHAR(600)", maxLength: 600, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MessageFiles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MessageFiles_Messages_MessageId",
                        column: x => x.MessageId,
                        principalTable: "Messages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ProductImages",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProductId = table.Column<int>(type: "int", nullable: false),
                    ImagePath = table.Column<string>(type: "VARCHAR(600)", maxLength: 600, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductImages", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProductImages_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserFavoriteProducts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ProductId = table.Column<int>(type: "int", nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserFavoriteProducts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserFavoriteProducts_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserFavoriteProducts_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Electronics" },
                    { 2, "Books" },
                    { 3, "Games" },
                    { 4, "Clothes" },
                    { 5, "Shoes" },
                    { 6, "Toys" }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Admin" },
                    { 2, "User" },
                    { 3, "Seller" }
                });

            migrationBuilder.InsertData(
                table: "Universities",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Adana Alparslan Türkeş Bilim Ve Teknoloji Üniversitesi" },
                    { 2, "Adıyaman Üniversitesi" },
                    { 3, "Afyon Kocatepe Üniversitesi" },
                    { 4, "Ağrı İbrahim Çeçen Üniversitesi" },
                    { 5, "Ahi Evran Üniversitesi" },
                    { 6, "Aksaray Üniversitesi" },
                    { 7, "Amasya Üniversitesi" },
                    { 8, "Anadolu Üniversitesi" },
                    { 9, "Ankara Hacı Bayram Veli Üniversitesi" },
                    { 10, "Ankara Üniversitesi" },
                    { 11, "Ardahan Üniversitesi" },
                    { 12, "Artvin Çoruh Üniversitesi" },
                    { 13, "Atatürk Üniversitesi" },
                    { 14, "Balıkesir Üniversitesi" },
                    { 15, "Bartın Üniversitesi" },
                    { 16, "Batman Üniversitesi" },
                    { 17, "Bayburt Üniversitesi" },
                    { 18, "Bilecik Şeyh Edebali Üniversitesi" },
                    { 19, "Bingöl Üniversitesi" },
                    { 20, "Bitlis Eren Üniversitesi" },
                    { 21, "Boğaziçi Üniversitesi" },
                    { 22, "Bozok Üniversitesi" },
                    { 23, "Bülent Ecevit Üniversitesi" },
                    { 24, "Celal Bayar Üniversitesi" },
                    { 25, "Cumhuriyet Üniversitesi" },
                    { 26, "Çanakkale Onsekiz Mart Üniversitesi" },
                    { 27, "Çankırı Karatekin Üniversitesi" },
                    { 28, "Çukurova Üniversitesi" },
                    { 29, "Deniz Harp Okulu" },
                    { 30, "Dicle Üniversitesi" },
                    { 31, "Dokuz Eylül Üniversitesi" },
                    { 32, "Dumlupınar Üniversitesi" },
                    { 33, "Düzce Üniversitesi" },
                    { 34, "Ege Üniversitesi" },
                    { 35, "Erciyes Üniversitesi" },
                    { 36, "Erzincan Binali Yıldırım Üniversitesi" },
                    { 37, "Erzurum Teknik Üniversitesi" },
                    { 38, "Eskişehir Osmangazi Üniversitesi" },
                    { 39, "Fırat Üniversitesi" },
                    { 40, "Galatasaray Üniversitesi" },
                    { 41, "Gazi Üniversitesi" },
                    { 42, "Gaziantep Üniversitesi" },
                    { 43, "Gaziosmanpaşa Üniversitesi" },
                    { 44, "Gebze Teknik Üniversitesi" },
                    { 45, "Giresun Üniversitesi" },
                    { 46, "Gümüşhane Üniversitesi" },
                    { 47, "Hacettepe Üniversitesi" },
                    { 48, "Hakkari Üniversitesi" },
                    { 49, "Harran Üniversitesi" },
                    { 50, "Hitit Üniversitesi" },
                    { 51, "Iğdır Üniversitesi" },
                    { 52, "İnönü Üniversitesi" },
                    { 53, "İskenderun Teknik Üniversitesi" },
                    { 54, "İstanbul Medeniyet Üniversitesi" },
                    { 55, "İstanbul Teknik Üniversitesi" },
                    { 56, "İstanbul Üniversitesi" },
                    { 57, "İzmir Bakırçay Üniversitesi" },
                    { 58, "İzmir Demokrasi Üniversitesi" },
                    { 59, "İzmir Kâtip Çelebi Üniversitesi" },
                    { 60, "İzmir Yüksek Teknoloji Enstitüsü" },
                    { 61, "Kafkas Üniversitesi" },
                    { 62, "Kahramanmaraş Sütçü İmam Üniversitesi" },
                    { 63, "Karabük Üniversitesi" },
                    { 64, "Karadeniz Teknik Üniversitesi" },
                    { 65, "Karamanoğlu Mehmetbey Üniversitesi" },
                    { 66, "Kastamonu Üniversitesi" },
                    { 67, "Kırıkkale Üniversitesi" },
                    { 68, "Kırklareli Üniversitesi" },
                    { 69, "Kırşehir Ahi Evran Üniversitesi" },
                    { 70, "Kilis 7 Aralık Üniversitesi" },
                    { 71, "Kocaeli Üniversitesi" },
                    { 72, "Konya Gıda ve Tarım Üniversitesi" },
                    { 73, "KTO Karatay Üniversitesi" },
                    { 74, "Maltepe Üniversitesi" },
                    { 75, "Mardin Artuklu Üniversitesi" },
                    { 76, "Marmara Üniversitesi" },
                    { 77, "Mehmet Akif Ersoy Üniversitesi" },
                    { 78, "Mersin Üniversitesi" },
                    { 79, "Mimar Sinan Güzel Sanatlar Üniversitesi" },
                    { 80, "Muğla Sıtkı Koçman Üniversitesi" },
                    { 81, "Muş Alparslan Üniversitesi" },
                    { 82, "Mustafa Kemal Üniversitesi" },
                    { 83, "Namık Kemal Üniversitesi" },
                    { 84, "Necmettin Erbakan Üniversitesi" },
                    { 85, "Nevşehir Hacı Bektaş Veli Üniversitesi" },
                    { 86, "Niğde Ömer Halisdemir Üniversitesi" },
                    { 87, "Ordu Üniversitesi" },
                    { 88, "Orta Doğu Teknik Üniversitesi" },
                    { 89, "Osmaniye Korkut Ata Üniversitesi" },
                    { 90, "Ömer Halisdemir Üniversitesi" },
                    { 91, "Pamukkale Üniversitesi" },
                    { 92, "Polis Akademisi" },
                    { 93, "Recep Tayyip Erdoğan Üniversitesi" },
                    { 94, "Sakarya Üniversitesi" },
                    { 95, "Selçuk Üniversitesi" },
                    { 96, "Siirt Üniversitesi" },
                    { 97, "Sinop Üniversitesi" },
                    { 98, "Süleyman Demirel Üniversitesi" },
                    { 99, "Şırnak Üniversitesi" },
                    { 100, "Trakya Üniversitesi" },
                    { 101, "Tunceli Üniversitesi" },
                    { 102, "Türk-Alman Üniversitesi" },
                    { 103, "Türk Hava Kurumu Üniversitesi" },
                    { 104, "Türkiye Uluslararası İslam, Bilim ve Teknoloji Üniversitesi" },
                    { 105, "Uşak Üniversitesi" },
                    { 106, "Üsküdar Üniversitesi" },
                    { 107, "Van Yüzüncü Yıl Üniversitesi" },
                    { 108, "Yalova Üniversitesi" },
                    { 109, "Yıldız Teknik Üniversitesi" },
                    { 110, "Yıldırım Beyazıt Üniversitesi" },
                    { 111, "Yüzüncü Yıl Üniversitesi" },
                    { 112, "Zonguldak Bülent Ecevit Üniversitesi" }
                });

            migrationBuilder.InsertData(
                table: "SubCategories",
                columns: new[] { "Id", "CategoryId", "Name" },
                values: new object[,]
                {
                    { 1, 1, "Mobile" },
                    { 2, 1, "Laptop" },
                    { 3, 1, "Tablet" },
                    { 4, 2, "Novel" },
                    { 5, 2, "Comic" },
                    { 6, 3, "Action" },
                    { 7, 3, "Adventure" },
                    { 8, 4, "Shirt" },
                    { 9, 4, "Pants" },
                    { 10, 5, "Sneakers" },
                    { 11, 5, "Boots" },
                    { 12, 1, "Calculator" },
                    { 13, 5, "Sandal" },
                    { 14, 5, "Slipper" },
                    { 15, 4, "Shorts" },
                    { 16, 4, "T-shirt" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "Email", "EmailVerificationCode", "FirstName", "IsEmailVerified", "LastName", "PasswordHash", "PasswordVerificationToken", "RefreshToken", "RefreshTokenEndDate", "Status", "UniversityId", "UserName" },
                values: new object[] { 1, "210129049@ogr.atu.edu.tr", null, "Muhammet", true, "Kılınç", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "muhammetkilinc" });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "Email", "EmailVerificationCode", "FirstName", "LastName", "PasswordHash", "PasswordVerificationToken", "RefreshToken", "RefreshTokenEndDate", "Status", "UniversityId", "UserName" },
                values: new object[,]
                {
                    { 2, "210129001@ogr.atu.edu.tr", null, "Beyza", "Kılınç", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "beyza" },
                    { 3, "210129002@ogr.atu.edu.tr", null, "Osman", "Kaya", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "osmankaya" },
                    { 4, "mehmet@gmail.com", null, "Mehmet", "Ulutaş", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "mehmetulutas" },
                    { 5, "210129003@ogr.atu.edu.tr", null, "Ali", "Kaya", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "alikaya" },
                    { 6, "210129004@ogr.atu.edu.tr", null, "Veli", "Kaya", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 1, "velikaya" },
                    { 7, "210129005@ogr.atu.edu.tr", null, "Tarık", "köklü", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 2, "tarikkoklu" },
                    { 8, "210129006@ogr.atu.edu.tr", null, "Ayse", "Bozkurt", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 2, "aysebzkrt" },
                    { 9, "210129007@ogr.atu.edu.tr", null, "Ceren", "Tokgöz", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 2, "cerentkgz" },
                    { 10, "210129008@ogr.stu.edu.tr", null, "Kayra", "Kabakcioglu", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 2, "kayra" },
                    { 11, "210129053@ogr.atu.edu.tr", null, "Ugur", "Tansal", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 7, "ugurtansal" },
                    { 12, "210129009@ogr.atu.edu.tr", null, "Batuhan", "Özsürmeli", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 7, "batuozsurmeli" },
                    { 13, "210129011@ogr.atu.edu.tr", null, "Raziye", "Kök", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 7, "raziye" },
                    { 14, "210129013@ogr.atu.edu.tr", null, "Mustafa", "Acikkar", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 7, "mustafaacikkar" },
                    { 15, "210129014@ogr.atu.edu.tr", null, "Yavuz", "Akkoç", "$2y$10$AHPdSk33YAaA4KAEyc9XcexFBlDY/ehwdmhvhg0snjKyXnjE9yvVC", null, null, null, "offline", 7, "beyzaakkoc" }
                });

            migrationBuilder.InsertData(
                table: "Messages",
                columns: new[] { "Id", "IsRead", "MessageText", "ReceiverId", "SenderId", "SentOn" },
                values: new object[] { 1, true, "Merhaba iyi günler, ürünü kaç tl ye satıyorsunuz", 2, 1, new DateTime(2025, 1, 22, 21, 6, 33, 782, DateTimeKind.Local).AddTicks(125) });

            migrationBuilder.InsertData(
                table: "UserPhotos",
                columns: new[] { "Id", "ImagePath", "UserId", "isProfilePhoto" },
                values: new object[,]
                {
                    { 1, "default-profile.png", 1, false },
                    { 2, "default-profile.png", 2, false },
                    { 3, "default-profile.png", 3, false },
                    { 4, "default-profile.png", 4, false },
                    { 5, "default-profile.png", 5, false },
                    { 6, "default-profile.png", 6, false },
                    { 7, "default-profile.png", 7, false },
                    { 8, "default-profile.png", 8, false },
                    { 9, "default-profile.png", 9, false },
                    { 10, "default-profile.png", 10, false },
                    { 11, "default-profile.png", 11, false },
                    { 12, "default-profile.png", 12, false },
                    { 13, "default-profile.png", 13, false },
                    { 14, "default-profile.png", 14, false },
                    { 15, "default-profile.png", 15, false }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 2, 2 },
                    { 3, 2, 3 },
                    { 4, 2, 4 },
                    { 5, 2, 5 },
                    { 6, 2, 6 },
                    { 7, 2, 7 },
                    { 8, 2, 8 },
                    { 9, 2, 9 },
                    { 10, 2, 10 },
                    { 11, 2, 11 },
                    { 12, 2, 12 },
                    { 13, 2, 13 },
                    { 14, 2, 14 },
                    { 15, 2, 15 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Categories_Name",
                table: "Categories",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MessageFiles_MessageId",
                table: "MessageFiles",
                column: "MessageId");

            migrationBuilder.CreateIndex(
                name: "IX_Messages_ReceiverId",
                table: "Messages",
                column: "ReceiverId");

            migrationBuilder.CreateIndex(
                name: "IX_Messages_SenderId",
                table: "Messages",
                column: "SenderId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductImages_ProductId",
                table: "ProductImages",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_Price",
                table: "Products",
                column: "Price");

            migrationBuilder.CreateIndex(
                name: "IX_Products_PublisherId",
                table: "Products",
                column: "PublisherId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_SubCategoryId",
                table: "Products",
                column: "SubCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_Title",
                table: "Products",
                column: "Title");

            migrationBuilder.CreateIndex(
                name: "IX_Roles_Name",
                table: "Roles",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_SubCategories_CategoryId",
                table: "SubCategories",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_SubCategories_Name",
                table: "SubCategories",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserFavoriteProducts_ProductId",
                table: "UserFavoriteProducts",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_UserFavoriteProducts_UserId",
                table: "UserFavoriteProducts",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserPhotos_UserId",
                table: "UserPhotos",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId",
                table: "UserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_UniversityId",
                table: "Users",
                column: "UniversityId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_UserName",
                table: "Users",
                column: "UserName",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MessageFiles");

            migrationBuilder.DropTable(
                name: "ProductImages");

            migrationBuilder.DropTable(
                name: "UserFavoriteProducts");

            migrationBuilder.DropTable(
                name: "UserPhotos");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "Messages");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "SubCategories");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropTable(
                name: "Universities");
        }
    }
}
