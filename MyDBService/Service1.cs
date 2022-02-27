using MyDBService.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace MyDBService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in both code and config file together.
    public class Service1 : IService1
    {
        public string GetData(int value)
        {
            return string.Format("You entered: {0}", value);
        }

        public CompositeType GetDataUsingDataContract(CompositeType composite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException("composite");
            }
            if (composite.BoolValue)
            {
                composite.StringValue += "Suffix";
            }
            return composite;
        }


        //----------------------Branch--------------------
        public List<String> SelectDistinctShopNameFromBranch()
        {
            Branch branch = new Branch();
            return branch.SelectDistinctShopName();
        }

        public DataSet SelectDistinctLocationFromBranch()
        {
            Branch branch = new Branch();
            return branch.SelectDistinctLocation();
        }

        public DataSet SearchFromBranch(string search, string location)
        {
            Branch branch = new Branch();
            return branch.Search(search, location);
        }

        public Branch SelectByIdFromBranch(Guid id)
        {
            Branch branch = new Branch();
            return branch.SelectById(id);
        }

        //----------------------Search--------------------
        public int CreateSearch(string searchString, Guid customerId)
        {
            Search search = new Search(searchString, customerId);
            return search.Insert();
        }

        public DataSet SelectByCustomerIdFromSearch(Guid customerId)
        {
            Search search = new Search();
            return search.SelectByCustomerId(customerId);
        }

        public int HaveDateFromSearch(string searchString, Guid customerId)
        {
            Search search = new Search();
            return search.HaveDate(searchString, customerId);
        }

        public int UpdateSearch(int id)
        {
            Search search = new Search();
            return search.Update(id);
        }

        public int DeleteFromSearch(Guid customerId)
        {
            Search search = new Search();
            return search.Delete(customerId);
        }

        //----------------------View--------------------
        public int InsertView(Guid branchId, Guid customerId)
        {
            View view = new View(branchId, customerId);
            return view.Insert();
        }
        public DataSet SelectByCustomerIdFromView(Guid customerId)
        {
            View view = new View();
            return view.SelectByCustomerId(customerId);
        }

        public int HaveDateFromView(Guid branchId, Guid customerId)
        {
            View view = new View();
            return view.HaveDate(branchId, customerId);
        }

        public int UpdateView(int id)
        {
            View view = new View();
            return view.Update(id);
        }
        public int DeleteFromView(Guid customerId)
        {
            View view = new View();
            return view.Delete(customerId);
        }

        //----------------------Review--------------------
        public int InsertReview(double rating, string comment, string title, Guid customerId, Guid branchId)
        {
            Review review = new Review(rating, comment, title, customerId, branchId);
            return review.Insert();
        }

        public DataSet SelectByBranchIdFromReview(Guid id, Guid customerId, string sort)
        {
            Review review = new Review();
            return review.SelectByBranchId(id, customerId, sort);
        }
        public DataSet SelectAllByBranchIdFromReview(Guid id, string sort)
        {
            Review review = new Review();
            return review.SelectAllByBranchId(id, sort);
        }
        public Review HaveExistingReview(Guid branchId, Guid customerId)
        {
            Review review = new Review();
            return review.HaveExistingReview(branchId, customerId);
        }

        public int UpdateReview(int id, String title, String comment, Double rating)
        {
            Review review = new Review();
            return review.Update(id, title, comment, rating);
        }
        public int DeleteReview(int id)
        {
            Review review = new Review();
            return review.Delete(id);
        }

        public DataSet SelectByCustomerIdFromReview(Guid id)
        {
            Review review = new Review();
            return review.SelectByCustomerId(id);
        }

        public double SelectRatingByBranchIdFromReview(Guid branchId)
        {
            Review review = new Review();
            return review.SelectRatingByBranchId(branchId);
        }

        public DataSet SelectReportedReview()
        {
            Review review = new Review();
            return review.SelectReportedReview();
        }

        public int AddNumReportToReview(int id)
        {
            Review review = new Review();
            return review.AddNumReport(id);
        }

        public int ResetNumReportToReview(int id)
        {
            Review review = new Review();
            return review.ResetNumReport(id);
        }
    }
}
