using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DataAccessLayer.Migrations
{
    /// <inheritdoc />
    public partial class mig7 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserFavoriteProducts_Products_ProductId",
                table: "UserFavoriteProducts");

            migrationBuilder.AddForeignKey(
                name: "FK_UserFavoriteProducts_Products_ProductId",
                table: "UserFavoriteProducts",
                column: "ProductId",
                principalTable: "Products",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserFavoriteProducts_Products_ProductId",
                table: "UserFavoriteProducts");

            migrationBuilder.AddForeignKey(
                name: "FK_UserFavoriteProducts_Products_ProductId",
                table: "UserFavoriteProducts",
                column: "ProductId",
                principalTable: "Products",
                principalColumn: "Id");
        }
    }
}
