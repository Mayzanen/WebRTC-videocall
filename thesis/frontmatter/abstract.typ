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

The objective of this master's thesis was to design and implement a browser-based multi-participant video calling application using WebRTC technology and to evaluate its functionality and accessibility. The thesis examined the principles of WebRTC, video conferencing architectures, network connectivity, and accessibility in web applications.

The application's user interface was developed using React and TypeScript. Media streams were forwarded using the VideoRoom plugin of Janus WebRTC Gateway, which follows the Selective Forwarding Unit (SFU) architecture. Network connectivity was supported by STUN and TURN services, with Coturn providing the TURN functionality. NGINX was used to provide secure HTTPS and WSS connections, and the system's services were deployed using Docker Compose. Accessibility requirements for the user interface were defined based on the WCAG 2.1 guidelines.

The application was evaluated by testing its core video calling functions across different network connections and in two desktop browsers. Accessibility was evaluated using automated checks and manual keyboard testing. All defined functional, non-functional, and accessibility requirements were met during testing. The application recovered from a short network interruption without user intervention but did not automatically re-establish connections after a longer interruption. This was identified as a limitation of the implementation and an area for further development. Accessibility issues related to text contrast and control icons were identified and corrected during testing.

The result of the thesis was a functional prototype of a multi-participant video calling application. The implementation demonstrated the suitability of the selected technologies for developing a browser-based video calling system. Key areas for further development include automatic connection recovery, performance evaluation, and more extensive device compatibility and accessibility testing.