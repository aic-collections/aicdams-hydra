describe("Grant", function() {
  var person = require('sufia/permissions/person');
  var group = require('sufia/permissions/group');
  var pkg = require('sufia/permissions/grant');
  var target;

  describe("with a person", function() {
    beforeEach(function() {
      loadFixtures('grant.html');
      var agent = new person.Person('Hannah');
      target = new pkg.Grant(agent, 'read', 'View/Download');
    })

    it("sets the label", function() {
      expect(target.label).toEqual("hannah@artic.edu");
    })
  })

  describe("with a group", function() {
    beforeEach(function() {
      loadFixtures('grant.html');
      var agent = new group.Group('GroupName');
      target = new pkg.Grant(agent, 'read', 'View/Download');
    })

    it("sets the label", function() {
      expect(target.label).toEqual("Group 2");
    })
  })  
})
