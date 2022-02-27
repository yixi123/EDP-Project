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
    class View
    {
        public Guid BranchId { get; set; }
        public Guid CustomerId { get; set; }

        public View() { }

        public View(Guid branchId, Guid customerId)
        {
            BranchId = branchId;
            CustomerId = customerId;
        }

        public int Insert()
        {
            string SQL = "INSERT INTO dbo.ViewHistory (viewDateTime, branchId, customerId) VALUES (@viewDateTime, @branchId, @customerId)";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@viewDateTime", DateTime.Now.ToString());
                    cmd.Parameters.AddWithValue("@branchId", BranchId);
                    cmd.Parameters.AddWithValue("@customerId", CustomerId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }

        public DataSet SelectByCustomerId(Guid customerId)
        {
            

            string SQL = "SELECT v.viewDateTime,b.* FROM dbo.ViewHistory as v INNER JOIN dbo.Branch as b ON v.branchId = b.id WHERE customerId = @customerId ORDER BY v.viewDateTime DESC;";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    sda.SelectCommand.Parameters.AddWithValue("@customerId", customerId);
                    conn.Open();
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    conn.Close();
                    return ds;
                }
            }
        }

        public int HaveDate(Guid branchId, Guid customerId)
        {
            int id = 0;
            string SQL = "SELECT viewDateTime,id from ViewHistory where branchId = @branchId AND customerId = @customerId";
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
                        if (reader.GetDateTime(0).Date == DateTime.Now.Date)
                        {
                            id = reader.GetInt32(1);
                        }
                    }
                    conn.Close();
                }
            }
            return id;
        }

        public int Update(int id)
        {
            string SQL = "UPDATE ViewHistory SET viewDateTime = @viewDateTime where id = @id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
 
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.Parameters.AddWithValue("@viewDateTime", DateTime.Now.ToString());
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }

        public int Delete(Guid customerId)
        {
            string SQL = "DELETE FROM ViewHistory WHERE customerId = @customerId";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return rowsAffected;
                }
            }
        }
    }
}
