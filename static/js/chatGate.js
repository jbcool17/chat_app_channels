var FormView = React.createClass({
  handleUserSetSubmit: function(data) {
    console.log('handleCommentSubmit', data.url, data.user)
    
    var re = /mr|ws|lr/;
    var chat = re.exec(data.url);

    switch(chat[0]) {
      case "mr":
          window.location.pathname = "/mr/" + data.user;
          break;
      case "lr":
          window.location.pathname = "/lr/" + data.user;
          break;
      case "ws":
          window.location.pathname = "/ws/" + data.user;
          break;
      default:
          console.log("not found.")
    }
  },
  render: function() {
    return (
      <div className="commentBox">
        <UserForm chatName="Manual Reload" url="/mr/user"onCommentSubmit={this.handleUserSetSubmit} />
        <br/>
        <UserForm chatName="Live Reload" url="/lr/user"onCommentSubmit={this.handleUserSetSubmit} />
        <br/>
        <UserForm chatName="Websockets" url="/ws"onCommentSubmit={this.handleUserSetSubmit} />    
      </div>
    );
  }
});


var UserForm = React.createClass({
  getInitialState: function() {
    return {user: ''};
  },
  handleChange: function(e) {
    this.setState({user: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var user = this.state.user.trim();
    if (!user) {
      return;
    }
      
    console.log(user, this.props.url)
    this.props.onCommentSubmit({user: user, url: this.props.url});
    this.setState({user: ''});
  },
  render: function() {
    return (
      <form className="userForm" action={this.props.url} onSubmit={this.handleSubmit} method="post">
      <h3>{this.props.chatName} </h3>
        <label> USER: </label>
          <input type="text" placeholder="Enter user name." value={this.state.user} onChange={this.handleChange} />
          <input className="btn btn-sm btn-primary" type="submit" onChange={this.handleSubmit}/>
      </form> 
    );
  }
});

ReactDOM.render(
  <FormView/>,
  document.getElementById('content')
);