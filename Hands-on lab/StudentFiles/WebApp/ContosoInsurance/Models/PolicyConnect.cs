namespace ContosoInsurance.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class PolicyConnect : DbContext
    {
        public PolicyConnect()
            : base("name=PolicyConnect")
        {
        }

        public virtual DbSet<Dependent> Dependents { get; set; }
        public virtual DbSet<Person> People { get; set; }
        public virtual DbSet<Policy> Policies { get; set; }
        public virtual DbSet<PolicyHolder> PolicyHolders { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Person>()
                .HasMany(e => e.Dependents)
                .WithRequired(e => e.Person)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Person>()
                .HasMany(e => e.PolicyHolders)
                .WithRequired(e => e.Person)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Policy>()
                .Property(e => e.DefaultDeductible)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Policy>()
                .Property(e => e.DefaultOutOfPocketMax)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Policy>()
                .HasMany(e => e.PolicyHolders)
                .WithRequired(e => e.Policy)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<PolicyHolder>()
                .Property(e => e.PolicyAmount)
                .HasPrecision(19, 4);

            modelBuilder.Entity<PolicyHolder>()
                .Property(e => e.Deductible)
                .HasPrecision(19, 4);

            modelBuilder.Entity<PolicyHolder>()
                .Property(e => e.OutOfPocketMax)
                .HasPrecision(19, 4);
        }
    }
}
