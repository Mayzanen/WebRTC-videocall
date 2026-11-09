/** abstract.typ
 *
 * Fill in the English abstract of your thesis in this file. The
 * preamble is imported, in case you wish to use commands defined
 * there.
 *
***/

#pdf.attach(
  "abstract.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "Typst source code for the English abstract of this thesis.",
)

#import "../preamble.typ": *

The objective of this master's thesis was to design and implement a browser-based multi-participant video calling application using Web Real-Time Communication (WebRTC) technology and to evaluate its functionality and accessibility. The thesis examined the principles of WebRTC and its suitability compared with other web-based communication approaches, video conferencing architectures, network connectivity, and accessibility in web applications.

The application's user interface was developed using React and TypeScript. Media streams were forwarded using the VideoRoom plugin of Janus WebRTC Gateway, which follows the Selective Forwarding Unit (SFU) architecture. Browser connectivity was supported by a public Session Traversal Utilities for NAT (STUN) service for address discovery and a Traversal Using Relays around NAT (TURN) service provided by Coturn for media relaying when needed. Janus was configured to use Coturn for both STUN and TURN services. NGINX provided secure connections for the web interface and signaling, and the system's services were deployed using Docker Compose. Accessibility requirements for the user interface were defined based on the Web Content Accessibility Guidelines (WCAG) 2.1.

The application was evaluated by testing its core video calling functions across different network connections and in two desktop browsers. Accessibility was evaluated using automated checks and manual keyboard testing. All defined functional, non-functional, and accessibility requirements were met during testing. The application recovered from a short network interruption without user intervention but did not automatically re-establish connections after a longer interruption. This was identified as a limitation of the implementation and an area for further development. Accessibility issues related to text contrast and control icons were identified and corrected during testing.

The result of the thesis was a functional prototype of a multi-participant video calling application. A key benefit of WebRTC compared with approaches such as Hypertext Transfer Protocol (HTTP)-based video streaming is its suitability for bidirectional, low-latency communication directly in the browser. The implementation demonstrated the suitability of the selected technologies for this purpose. Key areas for further development include automatic connection recovery, performance evaluation, and more extensive device compatibility and accessibility testing.