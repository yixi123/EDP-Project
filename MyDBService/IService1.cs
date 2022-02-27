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
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IService1
    {
        [OperationContract]
        string GetData(int value);

        [OperationContract]
        CompositeType GetDataUsingDataContract(CompositeType composite);

        // TODO: Add your service operations here
        //----------------------Branch--------------------
        [OperationContract]
        List<String> SelectDistinctShopNameFromBranch();

        [OperationContract]
        DataSet SelectDistinctLocationFromBranch();

        [OperationContract]
        DataSet SearchFromBranch(string search, string location);

        [OperationContract]
        Branch SelectByIdFromBranch(Guid id);

        //----------------------Search--------------------
        [OperationContract]
        int CreateSearch(string searchString, Guid customerId);

        [OperationContract]
        DataSet SelectByCustomerIdFromSearch(Guid customerId);

        [OperationContract]
        int HaveDateFromSearch(string searchString, Guid customerId);

        [OperationContract]
        int UpdateSearch(int id);

        [OperationContract]
        int DeleteFromSearch(Guid customerId);

        //----------------------View--------------------
        [OperationContract]
        int InsertView(Guid branchId, Guid customerId);

        [OperationContract]
        DataSet SelectByCustomerIdFromView(Guid customerId);

        [OperationContract]
        int HaveDateFromView(Guid branchId, Guid customerId);

        [OperationContract]
        int UpdateView(int id);

        [OperationContract]
        int DeleteFromView(Guid customerId);

        //----------------------Review--------------------
        [OperationContract]
        int InsertReview(double rating, string comment, string title, Guid customerId, Guid branchId);

        [OperationContract]
        DataSet SelectByBranchIdFromReview(Guid id, Guid customerId, string sort);

        [OperationContract]
        DataSet SelectAllByBranchIdFromReview(Guid id, string sort);

        [OperationContract]
        Review HaveExistingReview(Guid branchId, Guid customerId);

        [OperationContract]
        int UpdateReview(int id, String title, String comment, Double rating);

        [OperationContract]
        int DeleteReview(int id);

        [OperationContract]
        DataSet SelectByCustomerIdFromReview(Guid id);

        [OperationContract]
        double SelectRatingByBranchIdFromReview(Guid branchId);

        [OperationContract]
        DataSet SelectReportedReview();

        [OperationContract]
        int AddNumReportToReview(int id);

        [OperationContract]
        int ResetNumReportToReview(int id);
    }

    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    // You can add XSD files into the project. After building the project, you can directly use the data types defined there, with the namespace "MyDBService.ContractType".
    [DataContract]
    public class CompositeType
    {
        bool boolValue = true;
        string stringValue = "Hello ";

        [DataMember]
        public bool BoolValue
        {
            get { return boolValue; }
            set { boolValue = value; }
        }

        [DataMember]
        public string StringValue
        {
            get { return stringValue; }
            set { stringValue = value; }
        }
    }
}
