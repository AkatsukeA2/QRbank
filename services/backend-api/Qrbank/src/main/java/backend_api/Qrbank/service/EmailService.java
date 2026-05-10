package backend_api.Qrbank.service;

import lombok.AllArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@Service
@AllArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    public Mono<Void> sendEmail(String to, String subject, String body) {

        return Mono.fromRunnable(() -> {

                    SimpleMailMessage message = new SimpleMailMessage();
                    message.setFrom("akatsukia2itel@gmail.com");
                    message.setTo(to);
                    message.setSubject(subject);
                    message.setText(body);

                    mailSender.send(message);

                })
                .subscribeOn(Schedulers.boundedElastic())
                .then();
    }
}