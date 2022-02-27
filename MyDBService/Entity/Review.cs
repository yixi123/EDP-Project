using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MyDBService.Entity
{
    public class Review
    {
        public int Id { get; set; }
        public double Rating { get; set; }
        public string Comment { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateEdited { get; set; }
        public string Title { get; set; }
        public Guid CustomerId { get; set; }
        public Guid BranchId { get; set; }
        public int NumReport { get; set; }

        public Review() { }

        public Review(double rating, string comment, string title, Guid customerId, Guid branchId)
        {
            Rating = rating;
            Comment = comment;
            Title = title;
            CustomerId = customerId;
            BranchId = branchId;
        }

        public int Insert()
        {
            string SQL = "INSERT INTO Review (rating,comment,dateCreated,Title,customerId,branchId) VALUES (@rating, @comment, @dateCreated, @Title, @customerId, @branchId)";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@rating", Rating);
                    cmd.Parameters.AddWithValue("@comment", Comment);
                    cmd.Parameters.AddWithValue("@dateCreated", DateTime.Now.ToString());
                    cmd.Parameters.AddWithValue("@Title", Title);
                    cmd.Parameters.AddWithValue("@branchId", BranchId);
                    cmd.Parameters.AddWithValue("@customerId", CustomerId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }
        public DataSet SelectByBranchId(Guid id, Guid customerId, string sort)
        {
            switch (sort)
            {
                case "Newest":
                    sort = "DateCreated DESC";
                    break;
                case "Oldest":
                    sort = "DateCreated";
                    break;
                case "Highest Rating":
                    sort = "Rating DESC";
                    break;
                case "Lowest Rating":
                    sort = "Rating";
                    break;
                default:
                    sort = "DateCreated";
                    break;
            }
            string SQL = "SELECT * from Review where branchId = @paraId and customerId <> @customerId order by "+sort;
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    sda.SelectCommand.Parameters.AddWithValue("@paraId", id);
                    sda.SelectCommand.Parameters.AddWithValue("@customerId", customerId);
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    return ds;
                }
            }
        }
        public DataSet SelectAllByBranchId(Guid id, string sort)
        {
            string SQL = "SELECT * from Review where branchId = @paraId order by "+sort;
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    sda.SelectCommand.Parameters.AddWithValue("@paraId", id);
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    return ds;
                }
            }
        }
        public Review HaveExistingReview(Guid branchId, Guid customerId)
        {
            Id = -1;
            string SQL = "SELECT TOP 1 * from Review where branchId = @branchId AND customerId = @customerId";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@branchId", branchId);
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Id = reader.GetInt32(0);
                        Rating = double.Parse(reader["rating"].ToString());
                        Comment = reader["comment"].ToString();
                        Title = reader["Title"].ToString();
                        CustomerId = Guid.Parse(reader["customerId"].ToString());
                        BranchId = Guid.Parse(reader["branchId"].ToString());
                        DateCreated = DateTime.Parse(reader["dateCreated"].ToString());
                        if (reader["dateEdited"] != DBNull.Value)
                        {
                            DateEdited = DateTime.Parse(reader["dateEdited"].ToString());
                        }
                    }
                    conn.Close();
                }
            }
            return this;
        }

        public int Update(int id,string title, string comment, double rating)
        {
            string SQL = "UPDATE Review SET Title = @Title, comment = @comment, rating = @rating, dateEdited = @dateEdited where id = @id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@comment", comment);
                    cmd.Parameters.AddWithValue("@rating", rating);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.Parameters.AddWithValue("@dateEdited", DateTime.Now.ToString());
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }

        public int Delete(int id)
        {
            string SQL = "DELETE FROM Review WHERE id=@id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }

        public DataSet SelectByCustomerId(Guid id)
        {
            string SQL = "SELECT r.*,b.shopName from Review as r INNER JOIN branch as b ON r.branchId = b.id where customerId = @paraId ORDER BY r.dateCreated DESC";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    sda.SelectCommand.Parameters.AddWithValue("@paraId", id);
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    return ds;
                }
            }
        }

        public double SelectRatingByBranchId(Guid branchId)
        {
            double rating = 0;
            string SQL = "SELECT AVG(rating) as avgRating from Review where branchId = @paraId";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@paraId", branchId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();                  
                    while (reader.Read())
                    {
                        if (reader["avgRating"] != DBNull.Value)
                        {
                            rating = double.Parse(reader["avgRating"].ToString());
                        }
                    }
                    conn.Close();
                    return rating;
                }
            }
        }

        public DataSet SelectReportedReview()
        {
            string SQL = "SELECT * from Review where numReport > 0 order by numReport DESC";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    return ds;
                }
            }
        }

        public int AddNumReport(int id)
        {
            string SQL = "UPDATE Review SET numReport = numReport + 1 where id = @id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }

        public int ResetNumReport(int id)
        {
            string SQL = "UPDATE Review SET numReport = 0 where id = @id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }
    }
}
