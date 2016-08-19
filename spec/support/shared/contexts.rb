# frozen_string_literal: true
shared_context "authenticated saml user" do
  let(:user) { create(:user1) }
  before do
    allow(controller).to receive(:valid_saml_credentials?).and_return(true)
    allow(controller).to receive(:clear_session_user).and_return(user)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_user).and_return(user.email)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_department).and_return(user.department)
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end
end

shared_context "authenticated admin user" do
  let(:user) { create(:admin) }
  before do
    allow(controller).to receive(:valid_saml_credentials?).and_return(true)
    allow(controller).to receive(:clear_session_user).and_return(user)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_user).and_return(user.email)
    allow_any_instance_of(Devise::Strategies::SamlAuthenticatable).to receive(:saml_department).and_return(user.department)
    allow_any_instance_of(User).to receive(:groups).and_return(["admin"])
  end
end
