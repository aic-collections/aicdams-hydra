# frozen_string_literal: true
class AICDocType < RDF::StrictVocabulary("http://definitions.artic.edu/doctypes/")
  term :IntResStillImage,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:GeneralStillImage"
  term :GeneralStillImage,
       label: "General"
  term :ConservationStillImageFrameHousingAndPacking,
       label: "Frame/Housing and Packing",
       "skos:broader": "aicdoctype:ConservationStillImage"
  term :ConservationStillImage,
       label: "Conservation"
  term :CuratorialStudyPhoto,
       label: "Study Photo",
       "skos:broader": "aicdoctype:CuratorialStillImage"
  term :CuratorialExhibitionPhoto,
       label: "Exhibition Photo",
       "skos:broader": "aicdoctype:CuratorialStillImage"
  term :CuratorialDepartmentPhoto,
       label: "Department Photo",
       "skos:broader": "aicdoctype:CuratorialStillImage"
  term :CuratorialEventPhoto,
       label: "Event Photo",
       "skos:broader": "aicdoctype:CuratorialStillImage"
  term :CuratorialStillImage,
       label: "Curatorial"
  term :DesignFile,
       label: "Design File",
       "skos:broader": "aicdoctype:MarketingStillImage"
  term :AdMaterial,
       label: "Ad Material",
       "skos:broader": "aicdoctype:MarketingStillImage"
  term :MarketingStillImage,
       label: "Marketing"
  term :ArchiveDocument,
       label: "Archive Document",
       "skos:broader": "aicdoctype:Imaging"
  term :ObjectPhotography,
       label: "Object Photography",
       "skos:broader": "aicdoctype:Imaging"
  term :ExhibitionPhoto,
       label: "Exhibition Photo",
       "skos:broader": "aicdoctype:Imaging"
  term :Lecture,
       label: "Lecture",
       "skos:broader": "aicdoctype:EventPhotography"
  term :CommitteeMeeting,
       label: "Committee Meeting",
       "skos:broader": "aicdoctype:EventPhotography"
  term :MembershipEvent,
       label: "Membership event",
       "skos:broader": "aicdoctype:EventPhotography"
  term :GalleryTour,
       label: "Gallery Tour",
       "skos:broader": "aicdoctype:EventPhotography"
  term :EducationProgram,
       label: "Education Program",
       "skos:broader": "aicdoctype:EventPhotography"
  term :BehindTheScenes,
       label: "Behind-the-scenes",
       "skos:broader": "aicdoctype:EventPhotography"
  term :Seminar,
       label: "Seminar",
       "skos:broader": "aicdoctype:EventPhotography"
  term :DonorEvent,
       label: "Donor event",
       "skos:broader": "aicdoctype:EventPhotography"
  term :MellonProgram,
       label: "Mellon Program",
       "skos:broader": "aicdoctype:EventPhotography"
  term :SupportGroup,
       label: "SupportGroup",
       "skos:broader": "aicdoctype:EventPhotography"
  term :Marketing,
       label: "Marketing",
       "skos:broader": "aicdoctype:EventPhotography"
  term :EventPhotography,
       label: "Event Photography",
       "skos:broader": "aicdoctype:Imaging"
  term :Imaging,
       label: "Imaging"
  term :FacilityStillImage,
       label: "Facility",
       "skos:broader": "aicdoctype:RegistrationStillImage"
  term :InstallationStillImage,
       label: "Installation",
       "skos:broader": "aicdoctype:RegistrationStillImage"
  term :ShippingStillImage,
       label: "Shipping (In And Out)",
       "skos:broader": "aicdoctype:RegistrationStillImage"
  term :RegistrationDocumentationStillImage,
       label: "Documentation",
       "skos:broader": "aicdoctype:RegistrationStillImage"
  term :MiscRegistrationStillImage,
       label: "Other Or Misc.",
       "skos:broader": "aicdoctype:RegistrationStillImage"
  term :RegistrationStillImage,
       label: "Registration"
  term :InfoServicesArchitectureDrawing,
       label: "Architecture Diagram",
       "skos:broader": "aicdoctype:InfoServicesDiagramOrDrawing"
  term :InfoServicesFlowChart,
       label: "Flow Chart",
       "skos:broader": "aicdoctype:InfoServicesDiagramOrDrawing"
  term :InfoServicesDiagramOrDrawing,
       label: "Diagram or Drawing",
       "skos:broader": "aicdoctype:InfoServicesStillImage"
  term :InfoServicesEquipmentInfrastructurePhoto,
       label: "Equipment Or Infrastructure Documentation",
       "skos:broader": "aicdoctype:InfoServicesPhotography"
  term :InfoServicesPhotography,
       label: "Photography",
       "skos:broader": "aicdoctype:InfoServicesStillImage"
  term :InfoServicesStillImage,
       label: "Information Services"
  term :RyersonSpecialCollectionsStillImage,
       label: "Ryerson Special Collections",
       "skos:broader": "aicdoctype:RyersonLibraryStillImage"
  term :RyersonArchiveStillImage,
       label: "Archive",
       "skos:broader": "aicdoctype:RyersonLibraryStillImage"
  term :RyersonLibraryStillImage,
       label: "Ryerson Library"
  term :DesignConstructionStillImage,
       label: "Design and Construction"
  term :MuseumEducationStillImage,
       label: "Museum Education"
  term :DevelopmentStillImage,
       label: "Development"
  term :Correspondence,
       label: "Correspondence",
       "skos:broader": "aicdoctype:General"
  term :AcquisitionDocument,
       label: "Acquisition Document",
       "skos:broader": "aicdoctype:General"
  term :MasterVendorContract,
       label: "Master Vendor Contract",
       "skos:broader": "aicdoctype:Contract"
  term :ExhibitionContract,
       label: "Exhibition Contract",
       "skos:broader": "aicdoctype:Contract"
  term :ArtCommissionContract,
       label: "Art Commission Contract",
       "skos:broader": "aicdoctype:Contract"
  term :AuctionSalesContract,
       label: "Auction Sales Contract",
       "skos:broader": "aicdoctype:Contract"
  term :Contract,
       label: "Contract",
       "skos:broader": "aicdoctype:General"
  term :Fundraising,
       label: "Fundraising",
       "skos:broader": "aicdoctype:General"
  term :Ephemera,
       label: "Ephemera",
       "skos:broader": "aicdoctype:General"
  term :Confidential,
       label: "Confidential",
       "skos:broader": "aicdoctype:General"
  term :InstitutionalArchive,
       label: "Institutional Archive",
       "skos:broader": "aicdoctype:General"
  term :IntResText,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:General"
  term :General,
       label: "General"
  term :ExhibitionReceipt,
       label: "Exhibition Receipt",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :IncomingReceipt,
       label: "Incoming Receipt",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :OutgoingReceipt,
       label: "Outgoing Receipt",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :BillLading,
       label: "Bill of Lading",
       "skos:broader": "aicdoctype:Shipping"
  term :Shipping,
       label: "Shipping (out and in)",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :GeneralLiabilityCertificate,
       label: "General Liability Certificate",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :PowerAttorney,
       label: "Power of Attorney",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :CertificateInsurance,
       label: "Certificate of Insurance",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :LoanAgreement,
       label: "Loan Agreement",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :BorrowersAgreement,
       label: "Borrower's Agreement",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :LightLevelQuestionnaire,
       label: "Light Level Questionnaire",
       "skos:broader": "aicdoctype:FacilityReport"
  term :FacilityReport,
       label: "Facility Report",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :YellowSheets,
       label: "Yellow Sheets",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :Valuation,
       label: "Valuation",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :Installation,
       label: "Installation",
       "skos:broader": "aicdoctype:Schedule"
  term :Deinstallation,
       label: "Deinstallation",
       "skos:broader": "aicdoctype:Schedule"
  term :Exhibition,
       label: "Exhibition",
       "skos:broader": "aicdoctype:Schedule"
  term :Schedule,
       label: "Schedule",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :ExhibitionRequestForm,
       label: "Exhibition Request Form",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :Warranty,
       label: "Warranty",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :Indemnification,
       label: "Indemnification",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :RegistrationAudit,
       label: "Audit",
       "skos:broader": "aicdoctype:RegistrationDocument"
  term :RegistrationDocument,
       label: "Registration Document"
  term :Justification,
       label: "Justification",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :Appraisal,
       label: "Appraisal",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :PurchaseAgreement,
       label: "Purchase Agreement",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :BargainSaleAgreement,
       label: "Bargain Sale Agreement",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :JointGift,
       label: "Joint Gift",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :PledgeFundsAgreement,
       label: "Pledge of Funds Agreement",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :PromisedGiftAgreement,
       label: "Promised Gift Agreement",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :PartialInterestDeedGift,
       label: "Partial Interest Deed of Gift",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :FinalPartialInterestGift,
       label: "Final Partial Interest Gift",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :DeedGift,
       label: "Deed of Gift",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :Will,
       label: "Will",
       "skos:broader": "aicdoctype:Bequest"
  term :Bequest,
       label: "Bequest",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :ConditionReport,
       label: "Condition Report",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :AuctionDocument,
       label: "Auction Document",
       "skos:broader": "aicdoctype:Provenance"
  term :UnclaimedPropertyDocumentation,
       label: "Unclaimed Property Documentation",
       "skos:broader": "aicdoctype:Provenance"
  term :CorrespondenceOther,
       label: "Correspondence",
       "skos:broader": "aicdoctype:Provenance"
  term :ProvenanceWorksheet,
       label: "Worksheet",
       "skos:broader": "aicdoctype:Provenance"
  term :Provenance,
       label: "Provenance",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :NAGPRA,
       label: "NAGPRA",
       "skos:broader": "aicdoctype:CulturalDocument"
  term :Treaty,
       label: "Treaty",
       "skos:broader": "aicdoctype:CulturalDocument"
  term :CulturalConsideration,
       label: "Cultural Consideration",
       "skos:broader": "aicdoctype:CulturalDocument"
  term :CulturalDocument,
       label: "Cultural Document",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :ArtLossCertificate,
       label: "Art Loss Certificate",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :InvoicePaymentRequest,
       label: "Invoice Payment Request",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :AuthenticationDocument,
       label: "Authentication Document",
       "skos:broader": "aicdoctype:CertificateAuthenticity"
  term :CertificateAuthenticity,
       label: "Certificate of Authenticity",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :PhotographInformationRecord,
       label: "Photograph Information Record",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :CopyrightLicense,
       label: "Copyright license",
       "skos:broader": "aicdoctype:Copyright"
  term :CopyrightCorrespondence,
       label: "Copyright Correspondence",
       "skos:broader": "aicdoctype:Copyright"
  term :Correspondence,
       label: "Correspondence",
       "skos:broader": "aicdoctype:Copyright"
  term :Copyright,
       label: "Copyright",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :UnclaimedPropertyDocumentation,
       label: "Unclaimed Property Documentation",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :SellerInvoice,
       label: "Seller Invoice",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :DirectorDiscretionaryAuthority,
       label: "Director's Discretionary Authority",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :ArtPurchaseFundingPlan,
       label: "Art Purchase Funding Plan",
       "skos:broader": "aicdoctype:AcquisitionPaperwork"
  term :AcquisitionPaperwork,
       label: "Acquisition Paperwork"
  term :MeetingMinutes,
       label: "Meeting Minutes",
       "skos:broader": "aicdoctype:CommitteeMeetingDocumentation"
  term :MeetingPresentation,
       label: "Meeting Presentation",
       "skos:broader": "aicdoctype:CommitteeMeetingDocumentation"
  term :MeetingAgenda,
       label: "Meeting Agenda",
       "skos:broader": "aicdoctype:CommitteeMeetingDocumentation"
  term :CommitteeMeetingDocumentation,
       label: "Committee Meeting Documentation",
       "skos:broader": "aicdoctype:Administrative"
  term :BoardTrustees,
       label: "Board of Trustees",
       "skos:broader": "aicdoctype:Administrative"
  term :ExecutiveCommittee,
       label: "Executive Committee",
       "skos:broader": "aicdoctype:Administrative"
  term :AdminPolicies,
       label: "Policies",
       "skos:broader": "aicdoctype:Administrative"
  term :AdminProcedures,
       label: "Procedures",
       "skos:broader": "aicdoctype:Administrative"
  term :AdminBestPractices,
       label: "Best Practices",
       "skos:broader": "aicdoctype:Administrative"
  term :AdminTrainingToolsVideo,
       label: "Video",
       "skos:broader": "aicdoctype:AdminTrainingTools"
  term :AdminTrainingToolsGuide,
       label: "Guide",
       "skos:broader": "aicdoctype:AdminTrainingTools"
  term :AdminTrainingTools,
       label: "Training Tools",
       "skos:broader": "aicdoctype:Administrative"
  term :Administrative,
       label: "Administrative"
  term :ArtistBiography,
       label: "Artist Biography",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :Article,
       label: "Article",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :ArtistWorkSpecs,
       label: "Artist Work Specs",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :Curatorial,
       label: "Curatorial",
       "skos:broader": "aicdoctype:ScholarlyResearch"
  term :OutsideResearcher,
       label: "Outside Researcher",
       "skos:broader": "aicdoctype:ScholarlyResearch"
  term :ScholarlyResearch,
       label: "Scholarly Research",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :OldObjectCard,
       label: "Old Object Card",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :FrameDocumentation,
       label: "Frame Documentation",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :StolenArtDocumentation,
       label: "Stolen Art Documentation",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :CatalogingWorksheet,
       label: "Cataloging Worksheet",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :ArtistQuestionnaire,
       label: "Artist Questionnaire",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :AuctionCatalogue,
       label: "Auction Catalogue",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :NonLendingDocument,
       label: "Non-lending Document",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :IndemnityDocument,
       label: "Indemnity Document",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :Bibliography,
       label: "Bibliography",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :ObjectCard,
       label: "Object Card",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :LoanApprovalLetter,
       label: "Loan Approval Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanDeclineLetter,
       label: "Loan Decline Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanApprovalDeclineLetter,
       label: "Loan Approval And Decline Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanRequestForm,
       label: "Loan Request Form",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanRequestLetter,
       label: "Loan Request Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanAcknowledgmentLetter,
       label: "Loan Acknowledgment Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanAppealLetter,
       label: "Loan Appeal Letter",
       "skos:broader": "aicdoctype:LoanDocument"
  term :ImmunityFromSeizureApplication,
       label: "Immunity From Seizure Application",
       "skos:broader": "aicdoctype:LoanDocument"
  term :FederalRegister,
       label: "Federal Register",
       "skos:broader": "aicdoctype:LoanDocument"
  term :LoanDocument,
       label: "Loan Document",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :FinalChecklist,
       label: "Final Checklist",
       "skos:broader": "aicdoctype:ExhibitionDocumentation"
  term :ExhibDocSummary,
       label: "Summary",
       "skos:broader": "aicdoctype:ExhibitionDocumentation"
  term :ExhibDocInstallation,
       label: "Installation Document",
       "skos:broader": "aicdoctype:ExhibitionDocumentation"
  term :ExhibitionDocumentation,
       label: "Exhibition Documentation",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :LectureOther,
       label: "Lecture",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :CuratorialDocument,
       label: "Curatorial Document"
  term :AuctionHouse,
       label: "Auction House",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :Conservation,
       label: "Conservation",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :GiftDonationAgreement,
       label: "Gift (Donation) Agreement",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :BillSale,
       label: "Bill of Sale",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :PrivateSale,
       label: "Private Sale",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :DirectorsApprovalForm,
       label: "Directors Approval Form",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :DeaccessionBargainSaleAgreement,
       label: "Bargain Sale Agreement",
       "skos:broader": "aicdoctype:DeaccessionBargainSale"
  term :DeaccessionBargainSaleAgreementDealer,
       label: "Bargain Sale Agreement (Dealer)",
       "skos:broader": "aicdoctype:DeaccessionBargainSale"
  term :DeaccessionBargainSale,
       label: "Bargain Sale",
       "skos:broader": "aicdoctype:DeaccessionDocument"
  term :DeaccessionDocument,
       label: "Deaccession Document"
  term :Label,
       label: "Label",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :Catalogue,
       label: "Catalogue",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :DigitalScholarlyCatalogue,
       label: "DSC (Digital Scholarly Catalogue)",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :Book,
       label: "Book",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :Pamphlet,
       label: "Pamphlet",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :AnnualReport,
       label: "Annual Report",
       "skos:broader": "aicdoctype:PublicationsDocument"
  term :PublicationsDocument,
       label: "Publications Document"
  term :AnalysisReportSummary,
       label: "Summary",
       "skos:broader": "aicdoctype:AnalysisReport"
  term :AnalysisReport,
       label: "Analysis Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ConservationArticle,
       label: "Article",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ExaminationForAcquisitionConsideration,
       label: "Examination For Acquisition Consideration",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ExaminationForDeaccession,
       label: "Examination For Deaccession",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ExaminationReport,
       label: "Examination Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :FrameDocumentation,
       label: "Frame Documentation",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :IncidentReport,
       label: "Incident Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :IncomingConditionReport,
       label: "Incoming Condition Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :InterVenueConditionReport,
       label: "Inter-Venue Condition Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :MaterialAndTechniquesInformation,
       label: "Material And Techniques Information",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :NoteToFile,
       label: "Note To File",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :OutgoingConditionReport,
       label: "Outgoing Condition Report",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :RequestForAnalysis,
       label: "Request For Analysis",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :RequestForLoanExamination,
       label: "Request For Loan Examination",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ConservationIncomingLoanExam,
       label: "Incoming Loan Exam",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :TreatmentDocumentation,
       label: "Treatment Documentation",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ConservationDocument,
       label: "Conservation Document"
  term :RyersonSpecialCollectionsText,
       label: "Ryerson Special Collections",
       "skos:broader": "aicdoctype:RyersonLibraryText"
  term :RyersonArchiveTextPhoto,
       label: "Photo",
       "skos:broader": "aicdoctype:RyersonArchiveText"
  term :RyersonArchiveTextCatalog,
       label: "Catalog",
       "skos:broader": "aicdoctype:RyersonArchiveText"
  term :RyersonArchiveTextCombinedScan,
       label: "Combined Scan",
       "skos:broader": "aicdoctype:RyersonArchiveText"
  term :RyersonArchiveTextCorrespondence,
       label: "Correspondence",
       "skos:broader": "aicdoctype:RyersonArchiveText"
  term :RyersonArchiveTextExhibitionDocument,
       label: "Exhibition Document",
       "skos:broader": "aicdoctype:RyersonArchiveText"
  term :RyersonArchiveText,
       label: "Archive",
       "skos:broader": "aicdoctype:RyersonLibraryText"
  term :RyersonLibraryText,
       label: "Ryerson Library"
  term :DesignConstructionText,
       label: "Design and Construction"
  term :MuseumEducationText,
       label: "Museum Education"
  term :DevelopmentText,
       label: "Development"
  term :MarketingText,
       label: "Marketing"
  term :InfoServicesSoftwareSpecs,
       label: "Software Specs",
       "skos:broader": "aicdoctype:InfoServicesSpecSheet"
  term :InfoServicesHardwareSpecs,
       label: "Hardware Specs",
       "skos:broader": "aicdoctype:InfoServicesSpecSheet"
  term :InfoServicesInfrastructureSpecs,
       label: "Infrastructure Specs",
       "skos:broader": "aicdoctype:InfoServicesSpecSheet"
  term :InfoServicesSpecSheet,
       label: "Spec Sheet",
       "skos:broader": "aicdoctype:InfoServicesText"
  term :InfoServicesText,
       label: "Information Services"
  term :ExhibitDocumentationMovingImage,
       label: "Exhibition Documentation",
       "skos:broader": "aicdoctype:CuratorialMovingImage"
  term :MasterArtworkMovingImage,
       label: "Master",
       "skos:broader": "aicdoctype:ArtworkMovingImage"
  term :ExhibCopyArtworkMovingImage,
       label: "Exhibition Copy",
       "skos:broader": "aicdoctype:ArtworkMovingImage"
  term :AccessCopyArtworkMovingImage,
       label: "Access Copy",
       "skos:broader": "aicdoctype:ArtworkMovingImage"
  term :ArtworkMovingImage,
       label: "Work of Art",
       "skos:broader": "aicdoctype:CuratorialMovingImage"
  term :CuratorialMovingImage,
       label: "Curatorial"
  term :DEExhibProcessVideoMovingImage,
       label: "Process",
       "skos:broader": "aicdoctype:DEExhibVideoMovingImage"
  term :DEExhibVideoMovingImage,
       label: "Exhibition Video",
       "skos:broader": "aicdoctype:DEMovingImage"
  term :DEPromoMarketingMovingImage,
       label: "Marketing",
       "skos:broader": "aicdoctype:DEPromoMovingImage"
  term :DEPromoMovingImage,
       label: "Promotional",
       "skos:broader": "aicdoctype:DEMovingImage"
  term :DELectureEventMovingImage,
       label: "Lecture",
       "skos:broader": "aicdoctype:DEEventMovingImage"
  term :DEPerfEventMovingImage,
       label: "Performance",
       "skos:broader": "aicdoctype:DEEventMovingImage"
  term :DEEventMovingImage,
       label: "Event",
       "skos:broader": "aicdoctype:DEMovingImage"
  term :DESocialMediaMovingImage,
       label: "Social Media",
       "skos:broader": "aicdoctype:DEMovingImage"
  term :DEMovingImage,
       label: "Digital Experience"
  term :RyersonSpecialCollectionsMovingImage,
       label: "Ryerson Special Collections",
       "skos:broader": "aicdoctype:RyersonLibraryMovingImage"
  term :RyersonArchiveMovingImage,
       label: "Archive",
       "skos:broader": "aicdoctype:RyersonLibraryMovingImage"
  term :RyersonLibraryMovingImage,
       label: "Ryerson Library"
  term :IntResMovingImage,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:GeneralMovingImage"
  term :GeneralMovingImage,
       label: "General"
  term :MasterArtworkDataset,
       label: "Master",
       "skos:broader": "aicdoctype:ArtworkDataset"
  term :ExhibCopyArtworkDataset,
       label: "Exhibition Copy",
       "skos:broader": "aicdoctype:ArtworkDataset"
  term :AccessCopyArtworkDataset,
       label: "Access Copy",
       "skos:broader": "aicdoctype:ArtworkDataset"
  term :ArtworkDataset,
       label: "Work of Art",
       "skos:broader": "aicdoctype:CuratorialDataset"
  term :FMPDatabase,
       label: "FileMakerPro Database",
       "skos:broader": "aicdoctype:CuratorialDataset"
  term :CuratorialDataset,
       label: "Curatorial"
  term :RyersonSpecialCollectionsDataset,
       label: "Ryerson Special Collections",
       "skos:broader": "aicdoctype:RyersonLibraryDataset"
  term :RyersonArchiveDataset,
       label: "Archive",
       "skos:broader": "aicdoctype:RyersonLibraryDataset"
  term :RyersonFindingAidDataset,
       label: "Finding Aid",
       "skos:broader": "aicdoctype:RyersonLibraryDataset"
  term :RyersonLibraryDataset,
       label: "Ryerson Library"
  term :PublicationsDSCDataset,
       label: "DSC XML File",
       "skos:broader": "aicdoctype:PublicationsDataset"
  term :PublicationsDataset,
       label: "Publications"
  term :IntResDataset,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:GeneralDataset"
  term :GeneralDataset,
       label: "General"
  term :MasterArtworkSound,
       label: "Master",
       "skos:broader": "aicdoctype:ArtworkSound"
  term :ExhibCopyArtworkSound,
       label: "Exhibition Copy",
       "skos:broader": "aicdoctype:ArtworkSound"
  term :AccessCopyArtworkSound,
       label: "Access Copy",
       "skos:broader": "aicdoctype:ArtworkSound"
  term :ArtworkSound,
       label: "Work of Art",
       "skos:broader": "aicdoctype:CuratorialSound"
  term :CuratorialSound,
       label: "Curatorial"
  term :DEPodcastSound,
       label: "Podcast",
       "skos:broader": "aicdoctype:DESound"
  term :DELectureEventSound,
       label: "Lecture",
       "skos:broader": "aicdoctype:DEEventSound"
  term :DEEventSound,
       label: "Event",
       "skos:broader": "aicdoctype:DESound"
  term :DEAudioTourSound,
       label: "Audio Tour",
       "skos:broader": "aicdoctype:DESound"
  term :DESound,
       label: "Digital Experience"
  term :RyersonSpecialCollectionsSound,
       label: "Ryerson Special Collections",
       "skos:broader": "aicdoctype:RyersonLibrarySound"
  term :RyersonArchiveSound,
       label: "Archive",
       "skos:broader": "aicdoctype:RyersonLibrarySound"
  term :RyersonLibrarySound,
       label: "Ryerson Library"
  term :IntResSound,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:GeneralSound"
  term :GeneralSound,
       label: "General"
  term :IntResArchive,
       label: "Interpretive Resource",
       "skos:broader": "aicdoctype:GeneralArchive"
  term :GeneralArchive,
       label: "General"
end
