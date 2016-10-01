export class Person {
  /**
   * Initialize the Person 
   * @param {String} name the name of the agent
   */
  constructor(name) {
    this.type = 'person'
    this.name = name
    this.label = $('#select2-chosen-1').text()
  }
}

