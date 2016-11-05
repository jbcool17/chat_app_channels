var FormView = React.createClass({
  handleUserSetSubmit: function(data) {
    console.log(data)
    // window.location.pathname = "/chat/" + data.channel + '/' + data.user;
  },
  render: function() {
    return (
      <div className="commentBox">
        <UserFormView chatName="ChatGate" onCommentSubmit={this.handleUserSetSubmit} />
      </div>
    );
  }
});


var UserFormView = React.createClass({
  getInitialState: function() {
    return { user: '', channel: '', channels: ['test', 'test1'] };
  },
  handleUserChange: function(e) {
    this.setState({ user: e.target.value,
                    channelUrl: this.getPostUrl(this.state.channel, e.target.value)});
  },
  handleChannelChange: function(e) {
    var channel = e.target.value;
    this.setState({ channel: channel,
                    channelUrl: this.getPostUrl(channel, this.state.user) });
  },
  getPostUrl: function(channel, user){
    return "/chat/" + channel + '/' + user;;
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var user = this.state.user.trim();
    if (!user) {
      return;
    }

    var actionUrl = this.getPostUrl(this.state.channel, user);

    this.props.onCommentSubmit({ user: user, url: actionUrl });
  },
  render: function() {
    var optionNodes = this.state.channels.map(function(option) {
      return (
        <option key={option} value={option}>{option} Channel</option>
      );
    });
    return (
      <form className="userForm" action={this.state.channelUrl} onSubmit={this.handleSubmit} method="post">
      <h3> Choose A Chat </h3>
        <label> USER: </label>
          <input type="text" placeholder="Enter user name." value={this.state.user} onChange={this.handleUserChange} />
        <label>Chat Type: </label>
          <select onChange={this.handleChannelChange}>
            {optionNodes}
          </select>
          <input className="btn btn-sm btn-primary" type="submit" onChange={this.handleSubmit}/>
      </form>
    );
  }
});

ReactDOM.render(
  <FormView/>,
  document.getElementById('content')
);
