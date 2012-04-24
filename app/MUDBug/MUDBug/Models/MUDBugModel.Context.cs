﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Objects;

namespace MUDBug.Models
{
    public partial class DBStatsEntities : DbContext
    {
        public DBStatsEntities()
            : base("name=DBStatsEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<DayCheckList> DayCheckLists { get; set; }
        public DbSet<File_growth> File_growth { get; set; }
        public DbSet<IndexFrag> IndexFrags { get; set; }
        public DbSet<MonthCheckList> MonthCheckLists { get; set; }
        public DbSet<ProcdureExecutionTime> ProcdureExecutionTimes { get; set; }
        public DbSet<MUDBUGDriveSpace> MUDBUGDriveSpaces { get; set; }
        public DbSet<MUDBugErrorLog> MUDBugErrorLogs { get; set; }
        public DbSet<MUDBugRestart> MUDBugRestarts { get; set; }
    
        public virtual int CallDayCheck()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CallDayCheck");
        }
    }
}
