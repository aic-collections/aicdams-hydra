# frozen_string_literal: true
class AICDocType < RDF::StrictVocabulary("http://definitions.artic.edu/doctypes/")
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
  term :RyersonSpecialCollectionsStillImage,
       label: "Ryerson Special Collections",
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
  term :ExecutiveCommitteePollForm,
       label: "Executive Committee Poll Form",
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
  term :YearEndGiftDocument,
       label: "Year-End Gift Document",
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
  term :LoanApprovalLetter,
       label: "Loan Approval Letter",
       "skos:broader": "aicdoctype:CuratorialDocument"
  term :LoanDeclineLetter,
       label: "Loan Decline Letter",
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
  term :TreatmentDocumentation,
       label: "Treatment Documentation",
       "skos:broader": "aicdoctype:ConservationDocument"
  term :ConservationDocument,
       label: "Conservation Document"
  term :RyersonSpecialCollectionsText,
       label: "Ryerson Special Collections",
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
end
