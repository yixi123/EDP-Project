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
    public class Branch
    {
        public Guid Id { get; set; }
        public string ShopName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public string Address { get; set; }

        public Branch() { }

        public Branch(string shopName, string phoneNumber, string email, string description, string location, string address)
        {
            ShopName = shopName;
            PhoneNumber = phoneNumber;
            Email = email;
            Description = description;
            Location = location;
            Address = address;
        }

        public List<string> SelectDistinctShopName()
        {
            string SQL = "SELECT DISTINCT shopName from Branch";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    List<string> Names = new List<string>();
                    while (reader.Read())
                    {
                        Names.Add(reader.GetString(0));
                    }
                    conn.Close();
                    return Names;
                }
            }
        }

        public DataSet SelectDistinctLocation()
        {
            string SQL = "SELECT DISTINCT branchLocation from Branch ORDER BY branchLocation";
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

        public DataSet Search(string search,string location)
        {
            string[] items = search.Split(new char[0], StringSplitOptions.RemoveEmptyEntries);
            if(items.Length == 0)
            {
                items = new string[] {""};
            }
            var parameters = new string[items.Length];
            for (int i = 0; i < items.Length; i++)
            {
                parameters[i] = string.Format("@search{0}", i);
                items[i] = "%" + items[i] + "%";
            }

            string SQL = string.Format("SELECT DerivedTable.*,(SELECT cast(AVG(rating) as decimal(10,2)) FROM review r WHERE r.branchId = DerivedTable.id) as avgRating FROM " +
                "(SELECT * from Branch where shopName like @paraSearch" +
                " UNION Select * from Branch where branchAddress like @paraSearch" +
                " UNION Select * from Branch where description like @paraSearch" +
                " UNION SELECT * from Branch where (shopName like {0})" +
                " UNION SELECT * from Branch where (description like {1})" +
                ") DerivedTable where (@paraLocation='All' or branchLocation = @paraLocation)" +
                " order by case when shopName like @paraSearch then 1" +
                " when branchAddress like @paraSearch then 2" +
                " when description like @paraSearch then 3" +
                " when (shopName like {0}) then 4 else 5 end", string.Join(" or shopName like ", parameters), string.Join(" or description like ", parameters));
            
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter(SQL, conn))
                {
                    conn.Open();
                    sda.SelectCommand.Parameters.AddWithValue("@paraSearch", "%" + search + "%");
                    sda.SelectCommand.Parameters.AddWithValue("@paraLocation", location);
                    for (int i = 0; i < items.Length; i++)
                    {
                        sda.SelectCommand.Parameters.AddWithValue(parameters[i], items[i]);
                    }
                    
                    DataSet ds = new DataSet();
                    sda.Fill(ds);
                    conn.Close();
                    return ds;
                }
            }
        }

        public Branch SelectById(Guid id)
        {
            string SQL = "SELECT TOP 1 * from Branch where id = @paraId";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand(SQL, conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@paraId", id);
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Id = Guid.Parse(reader["id"].ToString());
                        ShopName = reader["shopName"].ToString();
                        PhoneNumber = reader["phoneNumber"].ToString();
                        Email = reader["email"].ToString();
                        Description = reader["description"].ToString();
                        Location = reader["branchLocation"].ToString();
                        Address = reader["branchAddress"].ToString();
                    }
                    conn.Close();
                    return this;
                }
            }
        }



    }
}
