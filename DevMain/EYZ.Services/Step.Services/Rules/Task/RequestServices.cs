using Gesi.Access.Database;
using Gesi.Core.Web.Helper;
using Insight.Database;
using Request.Services.Rules.Interface;
using System;
using System.Collections.Generic;

namespace Request.Services.Rules.Task
{
    public class RequestServices : IRequestTask
    {
        public List<dynamic> ChangeStatus(Guid Token, string Status, float PriceMT, int UpdatedId)
        {
            CheckIf.IsNull(Token, "Requerid Token");
            CheckIf.IsNull(Status, "Requerid Status");
            return Database.CurrentCnn.As<IRequest>().DB_ChangeStatusRequestVessel_Save(Token, Status, PriceMT, UpdatedId);
        }

        public List<dynamic> Continue(Guid token, List<Guid> Token, int UpdatedId)
        {
            return Database.CurrentCnn.As<IRequest>().DB_SearchVessel_Continue(token, String.Join(",", Token), UpdatedId);
        }

        public List<dynamic> ChangeStatusRequest(Guid Token, string Status, int UpdatedId)
        {
            CheckIf.IsNull(Token, "Requerid Token");
            CheckIf.IsNull(Status, "Requerid Status");
            return Database.CurrentCnn.As<IRequest>().DB_ChangeStatusRequest_Save(Token, Status, UpdatedId);
        }

        public dynamic GetRequest(Guid Token, int UpdatedId, int? VesselId)
        {
            CheckIf.IsNull(Token, "Requerid Token");
            return Database.CurrentCnn.As<IRequest>().DB_SearchVessel_Get(Token, UpdatedId, VesselId);
        }

        public List<dynamic> ItemsLiquidationForServices(Guid token, int UpdatedId)
        {
            return Database.CurrentCnn.As<IRequest>().DB_ItemsLiquidationForServices_List(token, UpdatedId);
        }

        public List<dynamic> RequesForServices(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                                int QuantityId, int LoadingConditionId, int UnLoadingConditionId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan)
        {
            return Database.CurrentCnn.As<IRequest>().DB_RequesForServices_List(PageIndex, PageSize, owner, UpdatedId, out TotalRecords, ProductId, StowageFactorId,
                                                  QuantityId, LoadingConditionId, UnLoadingConditionId, LoadPortId, LoadTerminalId, DischargePortId, DischargeTerminalId, StartLaycan, EndLaycan);
        }

        public List<dynamic> InboxCustomerRequest(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                               int QuantityId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan, String Status)
        {
            return Database.CurrentCnn.As<IRequest>().DB_InboxCustomer_List(PageIndex, PageSize, owner, UpdatedId, out TotalRecords, ProductId, StowageFactorId,
                                                  QuantityId, LoadPortId, LoadTerminalId, DischargePortId, DischargeTerminalId, StartLaycan, EndLaycan, Status);
        }

        public List<dynamic> InboxVesselRequest(int PageIndex, int PageSize, int owner, int UpdatedId, out int TotalRecords, int ProductId, int StowageFactorId,
                                               int QuantityId, int LoadPortId, int LoadTerminalId, int DischargePortId, int DischargeTerminalId, DateTime StartLaycan, DateTime EndLaycan, String Status)
        {
            return Database.CurrentCnn.As<IRequest>().DB_InboxVessel_List(PageIndex, PageSize, owner, UpdatedId, out TotalRecords, ProductId, StowageFactorId,
                                                  QuantityId, LoadPortId, LoadTerminalId, DischargePortId, DischargeTerminalId, StartLaycan, EndLaycan, Status);
        }

        public List<dynamic> ServiceLiquidationsForRquest(int PageIndex, int PageSize, Guid token, int UpdatedId, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IRequest>().DB_ServiceLiquidationsForRquest_List(PageIndex, PageSize, token, UpdatedId, out TotalRecords);
        }

        public List<dynamic> Step2(Guid Token, String Status, bool Continue, int UpdatedId)
        {
            CheckIf.IsNull(Token, "Requerid Token");
            return Database.CurrentCnn.As<IRequest>().DB_SearchVessel_Step2(Token, Status, Continue, UpdatedId);
        }

        public Guid Step(Guid Token, int ProductId, int StowageFactorId, float StowageFactor, int QuantityId, float Quantity, int ToleranceId, int Terms, int LoadingConditionId, int UnLoadingConditionId, int LoadPortId, int LoadTerminalId, float LoadingRate, int DischargePortId, int DischargeTerminalId, float UnLoadingRate, DateTime StartLaycan, DateTime EndLaycan, int UpdatedId)
        {
            CheckIf.IsNull(ProductId, "Requerid Product");
            CheckIf.IsNull(StowageFactorId, "Requerid Stowage Factor");
            CheckIf.IsNull(QuantityId, "Requerid Quantity");
            CheckIf.IsNull(ToleranceId, "Requerid Tolerance");
            CheckIf.IsNull(Terms, "Requerid Terms");
            CheckIf.IsNull(LoadingConditionId, "Requerid Loading Condition");
            CheckIf.IsNull(UnLoadingConditionId, "Requerid UnLoading Condition");
            CheckIf.IsNull(LoadPortId, "Requerid Load Port");
            CheckIf.IsNull(LoadTerminalId, "Requerid Load Terminal");
            CheckIf.IsNull(LoadingRate, "Requerid LoadingRate");
            CheckIf.IsNull(DischargePortId, "Requerid Discharge Port");
            CheckIf.IsNull(DischargeTerminalId, "Requerid Discharge Terminal");
            CheckIf.IsNull(UnLoadingRate, "Requerid UnLoading Rate");
            CheckIf.IsNull(StartLaycan, "Requerid Start Laycan");
            CheckIf.IsNull(EndLaycan, "Requerid End Laycan");
            return Database.CurrentCnn.As<IRequest>().DB_SearchVessel_Step1(Token, ProductId
                                                                         , StowageFactorId
                                                                         , StowageFactor
                                                                         , QuantityId
                                                                         , Quantity
                                                                         , ToleranceId
                                                                         , Terms
                                                                         , LoadingConditionId
                                                                         , UnLoadingConditionId
                                                                         , LoadPortId
                                                                         , LoadTerminalId
                                                                         , LoadingRate
                                                                         , DischargePortId
                                                                         , DischargeTerminalId
                                                                         , UnLoadingRate
                                                                         , StartLaycan
                                                                         , EndLaycan
                                                                         , UpdatedId);
        }

        public dynamic VariableLiquidation(Guid Token)
        {
            return  Database.CurrentCnn.As<IRequest>().DB_VariableLiquidation_Get(Token);
        }

        public void UpdateVariableLiquidation(Guid token ,float RateLoading, float RateUnLoading, float ValueLoadingCondition, float ValueUnLoadingCondition, float Quantity, float IfoLoadPort, float MgoLoadPort, float LoadingRate, float UnLoadingRate, float VesselSpeed, float VesselIfoConsumed, float VesselMgoConsumed, int UpdatedId)
        {
            Database.CurrentCnn.As<IRequest>().DB_UpdateVariableLiquidation(token,RateLoading,   RateUnLoading,   ValueLoadingCondition,   ValueUnLoadingCondition,   Quantity,   IfoLoadPort,   MgoLoadPort,   LoadingRate,   UnLoadingRate, VesselSpeed, VesselIfoConsumed, VesselMgoConsumed,   UpdatedId);
        }
    }
}