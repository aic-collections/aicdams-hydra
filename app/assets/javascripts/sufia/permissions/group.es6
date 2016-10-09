export class Group {
  /**
   * Initialize the Group 
   * @param {String} name the name of the agent
   */
  constructor(name) {
    this.type = 'group'
    this.name = name
    this.label = $('#new_group_name_skel option:selected').text()
  }
}
